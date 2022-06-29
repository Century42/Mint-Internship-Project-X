package csv;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class csvgenerator {

    private static final String[] strings = { "Cases", "Treated", "Deaths" };
    private static final int NUMFILES = 3;
    private static final int NUMENTRIES = 20;
    private static String type;
    private static int totalCases;

    public static void main(String args[]) {

        type = "hiv";

        for (int i = 0; i < NUMFILES; i++) {
            FileWriter file = makeFile(i + 1);
            totalCases = 0;
            for (int j = 0; j < NUMENTRIES; j++) {
                int index;
                int elementValue;

                if (!(totalCases > 0)) {
                    elementValue = (int) (Math.random() * 15) + 1;
                    totalCases += elementValue;
                    index = 0;
                } else {
                    elementValue = (int) (Math.random() * totalCases + 1);
                    index = (int) (Math.random() * 3);
                    if (index != 0)
                        totalCases -= elementValue;
                    else
                        totalCases += elementValue;
                }

                try {
                    file.write(strings[index] + "," + elementValue + "\n");
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
            closeFile(file);
        }
    }

    private static void closeFile(FileWriter file) {
        try {
            file.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static FileWriter makeFile(int index) {

        String fileName = type + "_" + index + ".csv";

        try {
            File file = new File(fileName);
            if (file.createNewFile()) {
                System.out.println("File created: " + file.getName());
            } else {
                System.out.println("File already exists.");
            }
            return new FileWriter(file);

        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }

        return null;
    }
}