## QStyledItemDelegate 和  QItemDelegate的区别, 以及自定义渲染(paint)

### 1. QStyledItemDelegate 和  QItemDelegate的区别

**QStyledItemDelegate** 和 **QItemDelegate** 都是继承 **QAbstractItemDelegate**，官方文档上说这两个类基本一样， 唯一不同是 **QStyledItemDelegate**  可以被 **Qss** 影响。

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021050801.png)



接下来查看 **QStyledItemDelegate** 和 **QItemDelegate** 的 **paint**() 源码( Qt版本为: 6.0.3): 

```c++
// QStyledItemDelegate 使用 QStyle 的 drawControl 方法绘制可受到参数 widget 的样式影响
void QStyledItemDelegate::paint(QPainter *painter,
        const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    Q_ASSERT(index.isValid());

    QStyleOptionViewItem opt = option;
    initStyleOption(&opt, index);

    const QWidget *widget = QStyledItemDelegatePrivate::widget(option);
    QStyle *style = widget ? widget->style() : QApplication::style();
    style->drawControl(QStyle::CE_ItemViewItem, &opt, painter, widget);
}
```

```c++
// QItemDelegate 使用 QPainter 原生绘制图形, Qss无法影响到 QItemDelegate

void QItemDelegate::paint(QPainter *painter,
                          const QStyleOptionViewItem &option,
                          const QModelIndex &index) const
{
    Q_D(const QItemDelegate);
    Q_ASSERT(index.isValid());

    QStyleOptionViewItem opt = setOptions(index, option);

    // prepare
    painter->save();
    if (d->clipPainting)
        painter->setClipRect(opt.rect);

    // get the data and the rectangles

    QVariant value;

    QPixmap pixmap;
    QRect decorationRect;
    value = index.data(Qt::DecorationRole);
    if (value.isValid()) {
        // ### we need the pixmap to call the virtual function
        pixmap = decoration(opt, value);
        if (value.userType() == QMetaType::QIcon) {
            d->tmp.icon = qvariant_cast<QIcon>(value);
            d->tmp.mode = d->iconMode(option.state);
            d->tmp.state = d->iconState(option.state);
            const QSize size = d->tmp.icon.actualSize(option.decorationSize,
                                                      d->tmp.mode, d->tmp.state);
            decorationRect = QRect(QPoint(0, 0), size);
        } else {
            d->tmp.icon = QIcon();
            decorationRect = QRect(QPoint(0, 0), pixmap.size());
        }
    } else {
        d->tmp.icon = QIcon();
        decorationRect = QRect();
    }

    QRect checkRect;
    Qt::CheckState checkState = Qt::Unchecked;
    value = index.data(Qt::CheckStateRole);
    if (value.isValid()) {
        checkState = static_cast<Qt::CheckState>(value.toInt());
        checkRect = doCheck(opt, opt.rect, value);
    }

    QString text;
    QRect displayRect;
    value = index.data(Qt::DisplayRole);
    if (value.isValid() && !value.isNull()) {
        text = d->valueToText(value, opt);
        displayRect = d->displayRect(index, opt, decorationRect, checkRect);
    }

    // do the layout

    doLayout(opt, &checkRect, &decorationRect, &displayRect, false);

    // draw the item

    drawBackground(painter, opt, index);
    drawCheck(painter, opt, checkRect, checkState);
    drawDecoration(painter, opt, decorationRect, pixmap);
    drawDisplay(painter, opt, displayRect, text);
    drawFocus(painter, opt, displayRect);

    // done
    painter->restore();
}

void QItemDelegate::drawBackground(QPainter *painter,
                                   const QStyleOptionViewItem &option,
                                   const QModelIndex &index) const
{
    if (option.showDecorationSelected && (option.state & QStyle::State_Selected)) {
        QPalette::ColorGroup cg = option.state & QStyle::State_Enabled
                                  ? QPalette::Normal : QPalette::Disabled;
        if (cg == QPalette::Normal && !(option.state & QStyle::State_Active))
            cg = QPalette::Inactive;

        painter->fillRect(option.rect, option.palette.brush(cg, QPalette::Highlight));
    } else {
        QVariant value = index.data(Qt::BackgroundRole);
        if (value.canConvert<QBrush>()) {
            QPointF oldBO = painter->brushOrigin();
            painter->setBrushOrigin(option.rect.topLeft());
            painter->fillRect(option.rect, qvariant_cast<QBrush>(value));
            painter->setBrushOrigin(oldBO);
        }
    }
}
```



下面是使用 **QItemDelegate** 和 **QStyledItemDelegate** 时，用 **Qss** 渲染**QTableView** 出现的不同效果:

调用代码:

```c++
    // 代码尝试对两个 TableView 的 item 进行 Qss样式渲染
    QString sQss = "QTableView::item{ border-bottom:1px solid red; }"
        "QTableView::item::selected{ color:red; background:#EFF4FF;}";
    m_pModel = new CTableModel(this);
    QStringList lstHeader = {"测试列"};
    m_pModel->SetHeader(lstHeader);
    QVector<CTableModel::TRowData> vtModelData;
    for (int i = 0; i < 10; i++)
    {
        CTableModel::TRowData tData;
        tData.sItem1 = QString("数据%1_%2").arg(i).arg(1);
        vtModelData.push_back(tData);
    }
    m_pModel->SetContentData(vtModelData);
    ui->tvItem->setModel(m_pModel);
    ui->tvStyleItem->setModel(m_pModel);

    m_pItemDelegate = new CTableDelegate(ui->tvItem);
    ui->tvItem->setItemDelegateForColumn(0, m_pItemDelegate);

    m_pStyleItemDelegate = new CStyledTableDelegate(ui->tvStyleItem);
    ui->tvStyleItem->setItemDelegateForColumn(0, m_pStyleItemDelegate);

    ui->tvItem->setStyleSheet(sQss);
    ui->tvStyleItem->setStyleSheet(sQss);
```

运行图如下， 左边的 **QTableView** 使用的是 **QItemDelegate**，**Qss** 样式没有效果；右边的 **QTableView** 使用的是 **QStyledItemDelegate** , 单元格有选中效果和红色下划线。

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021050901.png)



### 2. 自定义渲染(paint)

当你想在单元格显示一些特殊图形时, 只是使用 **QStyledItemDelegate** 提供API可能并不能满足需求, 此时需要重写 **paint** 函数, 当重写**paint**函数时, 我认为 **QStyledItemDelegate**  和 **QItemDelegate** 并没有区别。你可以像 **QItemDelegate** 的 **paint** 函数那样, 使用**QPainter** 原生绘制; 也可以像 **QStyledItemDelegate**  那样使用 **QStyle** 绘制，并且可以用 **Qss** 辅助渲染，十分方便炫酷!

当然在使用的过程中可能会遇到一些问题，请参考如下代码:

```c++
    // 初始化代码
	m_pwgtStyle = new QWidget();
    m_pbtnStyle = new QPushButton();
    QStringList qss;
    qss.append(QString("QPushButton{background-color:green;border:1px solid black; border-radius:6px;color:black;font-size:15px;}"));
    qss.append(QString("QPushButton:pressed{background-color:red;}"));
    qss.append(QString("QPushButton:!enabled{border:1px solid gray;color:gray;}"));
    m_pbtnStyle->setStyleSheet(qss.join(""));
```

```c++
void CStyledTableDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    QRect oRect = option.rect;

    QStyleOptionButton oStyleButton;
    oStyleButton.text = "测试按钮";
    QMargins oMargins(10, 5, 10, 5);
    oStyleButton.rect = oRect.marginsRemoved(oMargins);
    oStyleButton.state |= QStyle::State_Enabled;

    QApplication::style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
    //    m_pwgtStyle->style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
    //    m_pbtnStyle->style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
}

```

运行结果:

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021051001.png)



```c++
void CStyledTableDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    QRect oRect = option.rect;

    QStyleOptionButton oStyleButton;
    oStyleButton.text = "测试按钮";
    QMargins oMargins(10, 5, 10, 5);
    oStyleButton.rect = oRect.marginsRemoved(oMargins);
    oStyleButton.state |= QStyle::State_Enabled;

//    QApplication::style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
    // m_pwgtStyle 是QWidget类型
    m_pwgtStyle->style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
//    m_pbtnStyle->style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
}
```

运行结果:

![image-02](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021051002.png)



```c++
void CStyledTableDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    QRect oRect = option.rect;

    QStyleOptionButton oStyleButton;
    oStyleButton.text = "测试按钮";
    QMargins oMargins(10, 5, 10, 5);
    oStyleButton.rect = oRect.marginsRemoved(oMargins);
    oStyleButton.state |= QStyle::State_Enabled;

//    QApplication::style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
//    m_pwgtStyle->style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
    // m_pbtnStyle 是 QPushButton
    m_pbtnStyle->style()->drawControl(QStyle::CE_PushButton, &oStyleButton, painter, m_pbtnStyle);
}
```

运行结果:

![image-03](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021051003.png)

可以看到只有 **QPushButton** 的 **QStyle** 对象在渲染控件的时候有 **drawControl** 的第四个参数的 **Qss** 效果。 这是为什么呢? 答案是在初始化的时候，代码只是对 **m_pbtnStyle** 这个对象设置了 **Qss**, 导致 **m_pbtnStyle->style()** 对象类型为 **QStyleSheetStyle**(这个类型在 Qt 库里不公开), 而其他对象的 **style()** 类型是 **QWindowsVistaStyle**(这个类型也不公开)。 由此可以推测只有类型是 **QStyleSheetStyle** 类型才能渲染出 **Qss** 效果，只要 **m_pwgtStyle** 也设置 **Qss** 就可以渲染出带有**Qss**效果的**UI**

