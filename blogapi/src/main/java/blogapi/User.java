package blogapi;
import blogapi.*;
import java.security.spec.InvalidKeySpecException;

public class User {
    private int id;
    private String username ="vamsi";
    private String password= "vamsi@123"; 
    private String firstName;
    private String lastName;
    // ... other fields ...

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

   
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

	public String getEmail() {
		
		return null;
	}

    
}