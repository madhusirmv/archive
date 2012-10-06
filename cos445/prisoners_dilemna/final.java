/* Sample implementation of an agent that plays uniformly at random. */

import java.io.*;
import java.util.Random;

/* Be sure to replace Cos445 with your appropriately-capitalized NetID (eg. Ynaamad). 
Failing to do so correctly will result in compilation errors. */

class Pgrabows {

	public static void main(String[] args) throws IOException,
	InterruptedException {

		int totald = 0;
		Boolean hasdefected = new Boolean(false);
		Boolean lastc = new Boolean(false);
		Boolean choosed = new Boolean(false);
		
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
			adjustment = (totald*totald) /300;
			if (time_left <= 2){
				choosed = true;

			}
			else if (!hasdefected){
				choosed = false;	
			}
			else{
				if (time_left >= 99){
					if (rnd <= 98- adjustment) {
						choosed = false;
					}else{
						choosed = true;
					}
				}
				else if (lastc){
					if (rnd < 90- adjustment){
						choosed = false;
					}else{
						choosed = true;
					}
				}else{
					if (rnd < 20- adjustment){
						choosed = false;
					}else{
						choosed = true;
					}
				}
			}
			if (noise > 0){
				int randnoise = random.nextInt(1000);
				if (randnoise < (noise * 1000)){
					if (lastc == true){
						totald++;
					}else{
						totald--;
					}
				}
			}
			if (choosed){
				choice = "d";
			}else{
				choice = "c";
			}
			System.out.println(choice); // println() automatically flushes the
										// buffer.

			/*
			 * Read in what my opponent selected as his/her previous move and
			 * the amount of time I have left.
			 */
			in = reader.readLine().split(",");
			opponent_move = in[0];
			if (opponent_move == "c") {
				lastc = true;
			} else {
				hasdefected = true;
				lastc = false;
				totald++;
			}
			time_left = Double.parseDouble(in[1]);
		}

	}
}