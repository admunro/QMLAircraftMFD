#include "mainwindow.h"

MainWindow::MainWindow(EntityModel* entityModel,
                       EntityToTableModel* entityToTableModel,
                       QWidget *parent)
    : m_entityModel(entityModel),
    m_entityToTableModel(entityToTableModel),
    QMainWindow{parent}
{
    setWindowTitle("List Model as Table");
    resize(800, 600);

    // Create a central widget and layout
    QWidget* centralWidget = new QWidget(this);
    QVBoxLayout* layout = new QVBoxLayout(centralWidget);

    // Create the table view
    QTableView* tableView = new QTableView(centralWidget);
    layout->addWidget(tableView);

    // Create the list model with sample data
    //m_listModel = new MyListModel(this);


    // Create the table model adapter
    //m_entityModel = new ListToTableModel(m_listModel, this);

    // Set the model on the table view
    tableView->setModel(m_entityToTableModel);

    // Resize columns to content
    tableView->resizeColumnsToContents();

    setCentralWidget(centralWidget);
}
