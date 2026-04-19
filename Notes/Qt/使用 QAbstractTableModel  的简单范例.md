## 使用 QAbstractTableModel  的简单范例

QAbstractTableModel 结合 QTableView 使用，是QTableView的呈现的数据存储。继承QAbstractTableModel 必须重载以下几个纯虚函数(这些函数来自 QAbstractTableModel 的父类 QAbstractItemModel) : 

```c++
    Q_INVOKABLE virtual int rowCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE virtual int columnCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
```

其中 data 函数用来填充QTableView 每一个单元格内容。其 role 虽为int类型，但实际的值为 Qt::ItemDataRole 枚举类型 ，如下图:

![image-1](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-20210504164411469.png)

简单的例子:

```c++
// tablemodel.h

#include <QAbstractTableModel>
#include <QStringList>
#include <QVariant>

#define OVERLOAD_QT_CLASS_FUNCTION_DEGIN
#define OVERLOAD_QT_CLASS_FUNCTION_END

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
    Q_INVOKABLE virtual QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
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
```

使用 CTableModel 类如下:

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
```

 该代码块对 tableview 控件设置了四列，填充了10行数据



运行截图: 

![image-20210504195917915](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-20210504195917915.png)