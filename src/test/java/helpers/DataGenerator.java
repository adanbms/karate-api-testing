package helpers;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerator {
    public static String getRandomEmail() {
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

    public static JSONObject getRandomArticle() {
        Faker faker = new Faker();
        String title = faker.book().title();
        String description = faker.lorem().sentence();
        String body = faker.shakespeare().romeoAndJulietQuote();

        JSONObject request = new JSONObject();
        request.put("title", title);
        request.put("description", description);
        request.put("body", body);

        return request;
    }
}
