import { eventsSchema } from '../config/constants';

export default (sequelize, DataTypes) => {
  const Student = sequelize.define('Student',
    {
      id: {
        field: 'id_professor',
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      complementaryHours: {
        field: 'qt_complementary_hours',
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    },
    {
      schema: eventsSchema,
      tableName: 'tb_student'
    }
  );

  Student.associate = function (models) {
    /* Pertence */
    Student.belongsTo(models.User, {
      foreignKey: {
        field: 'id_user',
        allowNull: true
      },
      as: 'user'
    });

    Student.belongsTo(models.Course, {
      foreignKey: {
        field: 'id_course',
        allowNull: true
      },
      as: 'course'
    });

    Student.belongsTo(models.Term, {
      foreignKey: {
        field: 'id_term',
        allowNull: true
      },
      as: 'term'
    });
  }

  return Student;
}