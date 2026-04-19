## QTableView 使用委托(QItemDelegate)的简单范例



### 一、 实现点击QTableView 触发编辑效果

​	标题里的"编辑效果"可能让你有些疑惑， 类似 excel 表格软件，往往我们想编辑单元格内容时，会对对应的单元格双击，然后就可以修改其中的内容了，当然有些单元格内编辑的内容比较特殊，不是传统的文字，可能是勾选框显示是否勾选，也可能放一个进度条显示进度值等，这些只是方便用户输入，但也属于编辑的概念

​	QTableView 想要实现上面的效果 —— 双击触发单元格效果，需要使用 Qt 的委托功能。这是Qt 的Model/View 的框架了。具体该设计理念可以谷歌搜索，我仅在这里说一下其结构和负责部分。QTableView 用于显示控件并接收外部事件并将事件传递给 Delegate(委托)，委托负责单元格渲染和事件， Model用于存储数据。

​	下面为了理解 Delegate(委托) 和 Model(数据模型)的关系，我尝试继承 QAbstractTableModel 和 QItemDelegate,  实现点击QTableView 某一列单元格出发 SpinBox编辑效果

```c++
// tablemodel.h CTableModel除了需要实现 QAbstractTableModel 的抽象方法。还需要重写 flag() 方法的, 使某些单元格具有可编辑功能! 还需要实现 setData 功能, 后面的 委托类 在编辑完后会调用 setData 修改 CTableModel 里的数据

#include <QAbstractTableModel>
#include <QStringList>
#include <QVariant>
#include "commondefine.h"

class CTableModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    /**
     * @brief The TRowData struct 行数据
     */
    struct TRowData
    {
        QString sItem1;
        QString sItem2;
        QString sItem3;
        QString sItem4;
    };

private:
    /**
     * @brief The THeaderData struct 表头数据
     */
    struct THeaderData
    {
        Qt::Orientation eOrientation;   ///< 水平方向或者竖直方向
        QVariant oMetaData;     ///< 原生数据
        int iRole;              ///< 表头数据
    };

public:
    explicit CTableModel(QObject *parent);
    void SetHeader(const QStringList &_clstHeader);
    void SetContentData(const QVector<TRowData> &_cvTableData);

OVERLOAD_QT_CLASS_FUNCTION_DEGIN
/**
     * @brief setHeaderData 该函数为QAbstractItemModel的虚函数, 其内部功能未实现, 若想使用需要手动重载
     * @param section
     * @param orientation
     * @param value
     * @param role
     * @return
     */
    virtual bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value,int role = Qt::EditRole) override;
    Q_INVOKABLE virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE virtual int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE virtual bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);
    Q_INVOKABLE virtual QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE virtual Qt::ItemFlags flags(const QModelIndex &index) const override;
OVERLOAD_QT_CLASS_FUNCTION_END

private:
    QHash<int, THeaderData> m_hashSection2HHeader;     ///< 水平表头数据
    QHash<int, THeaderData> m_hashSection2VHeader;     ///< 垂直表头数据
    QVector<TRowData> m_vtRowData;  ///< 数据表
    int m_iColumnCount;  ///<  表头字段
};

```

```c++
// tablemodel.cpp

#include "tablemodel.h"

CTableModel::CTableModel(QObject * parent) : QAbstractTableModel(parent)
{

}

void CTableModel::SetHeader(const QStringList &_clstHeader)
{
    m_iColumnCount = _clstHeader.size();
    for (int i = 0; i < _clstHeader.size(); i++)
    {
        QString sHeader = _clstHeader.at(i);
        qDebug() << this->setHeaderData(i, Qt::Horizontal, sHeader, Qt::DisplayRole);
    }
}

void CTableModel::SetContentData(const QVector<CTableModel::TRowData> &_cvTableData)
{
    QAbstractItemModel::beginResetModel();
    m_vtRowData = _cvTableData;
    QAbstractItemModel::endResetModel();
}

bool CTableModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
    if (section < m_iColumnCount)
    {
        THeaderData tData;
        tData.eOrientation = Qt::Horizontal;
        tData.iRole = Qt::DisplayRole;
        tData.oMetaData = value;
        m_hashSection2HHeader[section] = tData;
        emit headerDataChanged(Qt::Horizontal, section, section);
        return true;
    }
    else{
        return false;
    }
}

int CTableModel::rowCount(const QModelIndex &parent) const
{
    return m_vtRowData.size();
}

int CTableModel::columnCount(const QModelIndex &parent) const
{
    return m_iColumnCount;
}

QVariant CTableModel::data(const QModelIndex &index, int role) const
{
    if (role == Qt::DisplayRole)
    {
        int iRow = index.row();
        int iColumn = index.column();
        if (iColumn < 4 && iRow < m_vtRowData.size())
        {
            switch (iColumn)
            {
            case 0:
                return m_vtRowData[iRow].sItem1;
            case 1:
                return m_vtRowData[iRow].sItem2;
            case 2:
                return m_vtRowData[iRow].sItem3;
            case 3:
                return m_vtRowData[iRow].sItem4;
            default:
                return QVariant();
            }
        }
        return QVariant();
    }
    else if(role == Qt::TextAlignmentRole)
    {
        return Qt::AlignCenter;
    }
    return QVariant();
}

bool CTableModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    int x = index.row(), y = index.column();
    if (x < m_vtRowData.size())
    {
        m_vtRowData[x].sItem4 = QString("%1").arg(value.toInt());
        emit dataChanged(index, index);     // 修改对应的单元显示内容
    }
    return true;
}

QVariant CTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (section < m_iColumnCount)
    {
        switch (role){
        case Qt::DisplayRole:
        {
            switch (orientation) {
            case Qt::Horizontal:
            {
                if (m_hashSection2HHeader.contains(section))
                {
                    return m_hashSection2HHeader[section].oMetaData;
                }
                else{
                    return QVariant();
                }
            }
            case Qt::Vertical:
            default:
                return QVariant();
            }
        }
        default:
            return QVariant();
        }
    }
    else{
        return QVariant();
    }
}

Qt::ItemFlags CTableModel::flags(const QModelIndex &index) const
{
    Qt::ItemFlags eFlag = QAbstractTableModel::flags(index);
    if (index.column() == 3)  // 某一列, 这里是第3列，使第三列具有编辑功能
    {
        return eFlag | Qt::ItemIsEditable;
    }
    else{
        return eFlag;
    }
}
```

```c++
// CTableDelegate 需要重写四个方法：

// createEditor: 当触发编辑效果时, 创建用于编辑的控件，注意如果 Model对象的 flag 属性没有 Qt::ItemIsEditable 则单元格没有编辑属性，自然无法调用委托的 createEditor 函数

// setEditorData: 当触发编辑效果时，调用完 createEditor 后调用该函数，在setEditorData函数里我们可以对控件设置初值

// setModelData: 该函数为单元格完成输入后，Qt自动调用的函数, 在这个函数里，我们可以将数据回写到 Model对象

// setModelData: updateEditorGeometry 用于渲染控件在单元格中的位置

#ifndef CTABLEDELEGATE_H
#define CTABLEDELEGATE_H

#include <QItemDelegate>
#include "commondefine.h"

class CTableDelegate : public QItemDelegate
{
    Q_OBJECT
public:
    explicit CTableDelegate(QObject *parent = nullptr);

OVERLOAD_QT_CLASS_FUNCTION_DEGIN
    QWidget *createEditor(QWidget *parent,
                          const QStyleOptionViewItem &option,
                          const QModelIndex &index) const override;
    void setEditorData(QWidget *editor,
                       const QModelIndex &index) const override;
    void setModelData(QWidget *editor,
                      QAbstractItemModel *model,
                      const QModelIndex &index) const override;
    void updateEditorGeometry(QWidget *editor,
                              const QStyleOptionViewItem &option,
                              const QModelIndex &index) const override;
OVERLOAD_QT_CLASS_FUNCTION_END
};

```

```c++
// tabledelegate.cpp
#include "tabledelegate.h"

#include <QSpinBox>
#include <QStyleOptionViewItem>

CTableDelegate::CTableDelegate(QObject * parent) : QItemDelegate(parent)
{

}

QWidget *CTableDelegate::createEditor(QWidget *parent, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    QSpinBox *pSpinBox = new QSpinBox(parent);
    pSpinBox->setMinimum(0);
    pSpinBox->setMaximum(INT_MAX);
    return pSpinBox;
}

void CTableDelegate::setEditorData(QWidget *editor, const QModelIndex &index) const
{
    QSpinBox *pSpinBox = static_cast<QSpinBox*>(editor);
    pSpinBox->setValue(10);
}

void CTableDelegate::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const
{
    QSpinBox *pSpinBox = static_cast<QSpinBox*>(editor);
    model->setData(index, pSpinBox->value());
}

void CTableDelegate::updateEditorGeometry(QWidget *editor, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    editor->setGeometry(option.rect);
}

```

主程序调用:

```c++
	m_pModel = new CTableModel(ui->tableView);
    QStringList lstHeader = {"测试1", "测试1", "测试1", "测试1"};
    m_pModel->SetHeader(lstHeader);
    ui->tableView->setModel(m_pModel);

    QVector<CTableModel::TRowData> vtModelData;
    for (int i = 0; i < 10; i++)
    {
        CTableModel::TRowData tData;
        tData.sItem1 = QString("数据%1_%2").arg(i).arg(1);
        tData.sItem2 = QString("数据%1_%2").arg(i).arg(2);
        tData.sItem3 = QString("数据%1_%2").arg(i).arg(3);
        tData.sItem4 = QString("数据%1_%2").arg(i).arg(4);
        vtModelData.push_back(tData);
    }
    m_pModel->SetContentData(vtModelData);

    m_pItemDelegate = new CTableDelegate(ui->tableView);
    ui->tableView->setItemDelegateForColumn(3, m_pItemDelegate);
```

### 二、运行截图:

![image_1](https://github.com/mingxingren/Notes/raw/master/resource/photo/2021050701.png)

![image_2](https://github.com/mingxingren/Notes/raw/master/resource/photo/2021050702.png)

注意：该运行效果可以直接用 QStandardItemModel  实现，不需要实现 QAbstractTableModel 那些方法，这里重写 QAbstractTableModel 类只是为了便于理解 委托 和 数据模型的调用关系