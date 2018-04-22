package edu.njit.cs631.fitness.service.api;


import edu.njit.cs631.fitness.data.entity.Member;
import edu.njit.cs631.fitness.data.entity.security.User;
import edu.njit.cs631.fitness.web.dto.UserDto;
import edu.njit.cs631.fitness.web.error.UserAlreadyExistException;

public interface UserService {

    User findUserByEmail(String email);

    Member findPersonByEmail(String email);

    User registerNewUserAccount(UserDto userDto) throws UserAlreadyExistException;

    void saveRegisteredUser(User user);

    void deleteUser(User user);

    User getUserByID(long id);

    void changeUserPassword(User user, String password);

    // TODO: A couple of items to implement on the tail end if there is time.
    // void createPasswordResetTokenForUser(User user, String token);
    // User getUserByPasswordResetToken(String token);
    // boolean checkIfValidOldPassword(User user, String password);
    // List<String> getUsersFromSessionRegistry();



}