import {
  Student,
  StudentEventEnrollment,
  Course,
  sequelize
} from '../models';
import ErrorHandler from '../helpers/ErrorHandler';

const studentEventEnrollmentService = {
  findByEvent: async (eventId) => {
    return await StudentEventEnrollment.findAll({
      where: { eventId },
      include: [
        {
          model: Student,
          as: 'student',
          include: [
            {
              model: Course,
              as: 'course'
            }
          ]
        },
      ],
      attributes: {
        exclude: ['eventId', 'studentId']
      }
    });
  },
  findByEventAndStudent: async (eventId, studentId) => {
    return await StudentEventEnrollment.findOne({
      where: { eventId, studentId },
      include: [],
    });
  },
};

export default studentEventEnrollmentService;