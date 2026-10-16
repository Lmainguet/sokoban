package sokoban;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class ProblemBuilder {

    public static void problemBuild(String jsonName, int level) throws Exception {

        String[] grid = jsonToStringArray(jsonName);

        int height = grid.length;
        int width = grid[0].length();

        PrintWriter writer = new PrintWriter(
            "src/main/java/sokoban/pddl/problem" + level + ".pddl"
        );

        // =========================================================
        // DEFINE
        // =========================================================

        writer.println("(define (problem Sokoban" + level + ")");
        writer.println("  (:domain robot-monde)");
        writer.println();

        // =========================================================
        // OBJECTS
        // =========================================================

        writer.println("  (:objects");

        // Robot
        writer.println("    r1 - robot");

        // Boîtes
        int numberOfBoxes = 0;

        for (int r = 0; r < height; r++) {
            for (int c = 0; c < grid[r].length(); c++) {

                char ch = grid[r].charAt(c);

                if (ch == '$' || ch == '*') {
                    numberOfBoxes++;
                }
            }
        }

        writer.print("    ");

        for (int i = 1; i <= numberOfBoxes; i++) {
            writer.print("b" + i + " ");
        }

        writer.println("- box");

        // Cases
        writer.print("    ");

        for (int i = 1; i <= height * width; i++) {
            writer.print("c" + i + " ");
        }

        writer.println("- cell");

        writer.println("  )");
        writer.println();

        // =========================================================
        // INIT
        // =========================================================

        writer.println("  (:init");

        int boxCount = 1;

        for (int r = 0; r < height; r++) {

            for (int c = 0; c < width; c++) {

                char ch = grid[r].charAt(c);

                int id = r * width + c + 1;

                String cell = "c" + id;

                switch (ch) {

                    // -------------------------------------------------
                    // Mur
                    // -------------------------------------------------

                    case '#':

                        writer.println(
                            "    (wall " + cell + ")"
                        );

                        break;

                    // -------------------------------------------------
                    // Objectif vide
                    // -------------------------------------------------

                    case '.':

                        writer.println(
                            "    (goal " + cell + ")"
                        );

                        writer.println(
                            "    (free " + cell + ")"
                        );

                        break;

                    // -------------------------------------------------
                    // Robot
                    // -------------------------------------------------

                    case '@':

                        writer.println(
                            "    (at-robot " + cell + ")"
                        );

                        // Le robot occupe la case
                        // mais elle n'est pas occupée par une boîte.
                        writer.println(
                            "    (free " + cell + ")"
                        );

                        break;

                    // -------------------------------------------------
                    // Boîte non placée
                    // -------------------------------------------------

                    case '$':

                        writer.println(
                            "    (at-box b" + boxCount + " " + cell + ")"
                        );
                        boxCount++;
                        break;

                    // -------------------------------------------------
                    // Boîte déjà sur un objectif
                    // -------------------------------------------------

                    case '*':

                         writer.println("    (at-box b" + boxCount + " " + cell + ")");
						writer.println("    (goal " + cell + ")");
						writer.println("    (box-on-goal " + cell + ")");
						boxCount++;

                        break;

                    // -------------------------------------------------
                    // Case vide
                    // -------------------------------------------------

                    case ' ':

                        writer.println(
                            "    (free " + cell + ")"
                        );

                        break;

                    // -------------------------------------------------
                    // Padding / caractère inconnu
                    // -------------------------------------------------

                    default:

                        writer.println(
                            "    (wall " + cell + ")"
                        );

                        break;
                }
            }
        }

        // =========================================================
        // ADJACENCES
        // =========================================================

        for (int r = 0; r < height; r++) {

            for (int c = 0; c < width; c++) {

                int id = r * width + c + 1;

                // -------------------------------------------------
                // Droite / gauche
                // -------------------------------------------------

                if (c < width - 1) {

                    writer.println(
                        "    (dir-right c" + id +
                        " c" + (id + 1) + ")"
                    );

                    writer.println(
                        "    (dir-left c" + (id + 1) +
                        " c" + id + ")"
                    );

                    writer.println(
                        "    (adjacent c" + id +
                        " c" + (id + 1) + ")"
                    );

                    writer.println(
                        "    (adjacent c" + (id + 1) +
                        " c" + id + ")"
                    );
                }

                // -------------------------------------------------
                // Bas / haut
                // -------------------------------------------------

                if (r < height - 1) {

                    writer.println(
                        "    (dir-down c" + id +
                        " c" + (id + width) + ")"
                    );

                    writer.println(
                        "    (dir-up c" + (id + width) +
                        " c" + id + ")"
                    );

                    writer.println(
                        "    (adjacent c" + id +
                        " c" + (id + width) + ")"
                    );

                    writer.println(
                        "    (adjacent c" + (id + width) +
                        " c" + id + ")"
                    );
                }
            }
        }

        writer.println("  )");
        writer.println();

        // =========================================================
        // GOAL
        // =========================================================

        writer.println("  (:goal (and");

        /*
         * Le but est que toutes les cases qui sont des objectifs
         * contiennent une boîte.
         *
         * Avec le domaine actuel, on ne peut pas écrire :
         *
         *     exists (?b - box) ...
         *
         * en STRIPS simple.
         *
         * On va donc utiliser le fait que les boîtes déjà présentes
         * sur les objectifs restent sur ces objectifs et que la
         * boîte non placée doit atteindre le dernier objectif.
         */

        // On récupère les positions des objectifs.
        int goalCount = 0;

		for (int r = 0; r < height; r++) {
			for (int c = 0; c < width; c++) {

				char ch = grid[r].charAt(c);
				int id = r * width + c + 1;

				if (ch == '.' || ch == '*') {
					writer.println(
						"    (box-on-goal c" + id + ")"
					);
				}
			}
		}

        /*
         * Pour chaque boîte déjà sur un objectif (*),
         * on impose qu'elle reste sur cet objectif.
         *
         * Pour une boîte $, on impose qu'elle arrive sur un
         * objectif encore vide (.).
         */

        boxCount = 1;

        for (int r = 0; r < height; r++) {

            for (int c = 0; c < width; c++) {

                char ch = grid[r].charAt(c);

                int id = r * width + c + 1;

                if (ch == '*') {

                    writer.println(
                        "    (at-box b" + boxCount +
                        " c" + id + ")"
                    );

                    boxCount++;
                }
            }
        }

        // Cherche les objectifs encore vides.
        for (int r = 0; r < height; r++) {

            for (int c = 0; c < width; c++) {

                char ch = grid[r].charAt(c);

                int id = r * width + c + 1;

                if (ch == '.') {

                    /*
                     * Ici on suppose qu'il reste une boîte à placer.
                     * Pour ton niveau actuel, c'est b3.
                     */

                    int unplacedBox = 1;

                    for (int rr = 0; rr < height; rr++) {

                        for (int cc = 0; cc < width; cc++) {

                            char boxChar = grid[rr].charAt(cc);

                            if (boxChar == '$') {

                                // Calcul du numéro de la boîte
                                int boxNumber = 1;

                                for (int rrr = 0; rrr <= rr; rrr++) {

                                    int maxC;

                                    if (rrr == rr) {
                                        maxC = cc;
                                    } else {
                                        maxC = grid[rrr].length();
                                    }

                                    for (int ccc = 0; ccc < maxC; ccc++) {

                                        char previous =
                                            grid[rrr].charAt(ccc);

                                        if (previous == '$'
                                            || previous == '*') {

                                            if (rrr == rr && ccc == cc) {
                                                unplacedBox = boxNumber;
                                            }

                                            boxNumber++;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    writer.println(
                        "    (at-box b" + unplacedBox +
                        " c" + id + ")"
                    );
                }
            }
        }

        writer.println("  ))");
        writer.println(")");

        writer.close();
    }

    // =============================================================
    // JSON -> grille
    // =============================================================

    public static String[] jsonToStringArray(String jsonName)
        throws FileNotFoundException, IOException, ParseException {

        Object jsonObj =
            new JSONParser().parse(
                new FileReader("config/" + jsonName)
            );

        JSONObject json = (JSONObject) jsonObj;

        String level = (String) json.get("testIn");

        System.out.println(
            "Le niveau choisi :\n" + level
        );

        level = level.replace("\r", "");

        String[] lines = level.split("\n");

        return lines;
    }
}