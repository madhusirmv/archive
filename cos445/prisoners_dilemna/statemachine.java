/* Sample implementation of an agent that plays uniformly at random. */

import java.io.*;
import java.util.Random;

/* Be sure to replace Cos445 with your appropriately-capitalized NetID (eg. Ynaamad). 
 Failing to do so correctly will result in compilation errors. */

class Pgrabows {

	public static void main(String[] args) throws IOException,
			InterruptedException {
 
                int totald = 0;
		Boolean threeagoc = new Boolean(false);
		Boolean twoagoc = new Boolean(false);
		Boolean lastc = new Boolean(false);
		Boolean hasdefected = new Boolean(false);
		/* For reading input. */
		String in[];
		String opponent_move;
		BufferedReader reader = new BufferedReader(new InputStreamReader(
				System.in));

		/* For selecting a random option. */
		String opts = "CD";
		Random random = new Random();

		/*
		 * Read in the number of rounds, amount of noise, and max execution
		 * time.
		 */
		String params[] = reader.readLine().split(",");
                int adjustment = 0;
		int num_rounds = Integer.parseInt(params[0]);
		double noise = Double.parseDouble(params[1]);
		double time_left = Double.parseDouble(params[2]);
		String choice;
		while (true) {
			/* Output a selection uniformly at random. */
			int rnd = random.nextInt(100);

			if (hasdefected == false) {
				if (rnd < 5) {
					choice = "d";
				} else {
					choice = "c";
				}
			} else {
				if (threeagoc && twoagoc && lastc) {
					// opponent cooperated on last 3 runs
					if (rnd < 3 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}
				} else if (lastc && twoagoc) {
					// opponent cooperated on last two runs
					if (rnd < 6 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}
				} else if (lastc && threeagoc) {
					if (rnd < 7 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}
				} else if (lastc) {
					// opponent cooperated only on last run
					if (rnd < 20 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}

				} else if (twoagoc && threeagoc) {
					if (rnd < 10 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}
				} else if (twoagoc) {
					if (rnd < 18 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}
				} else if (threeagoc) {

					if (rnd < 15 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}
				} else {
					// opponent defected on last 3 runs
					if (rnd < 85 + adjustment) {
						choice = "d";
					} else {
						choice = "c";
					}
				}
			}
			System.out.println(choice); // println() automatically flushes the
										// buffer.

			/*
			 * Read in what my opponent selected as his/her previous move and
			 * the amount of time I have left.
			 */
			in = reader.readLine().split(",");
			opponent_move = in[0];
			threeagoc = twoagoc;
			twoagoc = lastc;
			if (opponent_move == "c") {
				lastc = true;
			} else {
				lastc = false;
                                totald++;
			}
                        if (totald > 40 && lastc == false){
                                adjustment +=3;
                        }
			if (lastc == false && hasdefected == false) {
				hasdefected = true;
			}
			time_left = Double.parseDouble(in[1]);
		}

	}

}