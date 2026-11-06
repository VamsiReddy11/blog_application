package blogapi;

public class PasswordUtil {

    
    public static String getPlainPassword(String password) {
        return password; 
    }

    
    public static boolean verifyPassword(String inputPassword, String storedPassword) {
        return inputPassword.equals(storedPassword); 
    }
}
