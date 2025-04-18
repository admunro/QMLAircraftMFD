#pragma once

#include <QMainWindow>
#include <QTableView>
#include <QVBoxLayout>

#include "entitymodel.h"


class MainWindow : public QMainWindow
{

    public:

        MainWindow(EntityModel* entityModel,
                   EntityToTableModel* entityToTableModel,
                   QWidget* parent = nullptr);

    private:
        EntityModel* m_entityModel;
        EntityToTableModel* m_entityToTableModel;
};
