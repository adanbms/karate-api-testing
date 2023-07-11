package helpers;

import com.github.javafaker.Faker;

public class DataGenerator {
    public static String getRandomEmail(){
        Faker faker = new Faker();
        String email = faker.name().firstName().toLowerCase()
                        + faker.name().lastName().toLowerCase()
                        + faker.random().nextInt(0, 100).toString() 
                        + "@karate.test";

        return email;
    }

    public static String getRandomUserName() {
        Faker faker = new Faker();
        String userName = faker.name().username();
        return userName;
    }
}
