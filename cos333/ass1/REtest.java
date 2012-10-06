//import java.io.FileInputStream;
//import java.io.FileNotFoundException;
import java.util.Scanner;

public class REtest {

	public static void main(String[] args) {
	/*try {
			System.setIn(new FileInputStream(
					"/home/pgrabowski/phdvdev/workspace/Java1/REtests.txt"));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		Scanner in = new Scanner(System.in);

		String line;
		String at = "[@]";
		String[] tokens;
		String re;
		String text;
		String answer;
		int start, end;
		//int linenum;
		boolean ret, shouldfind;

		start = 0;
		end = 0;
		//linenum = 1;

		do {
			line = in.nextLine();

			if (line.equals("")) {
				//System.out.println(linenum);
				if(in.hasNextLine()){
				line = in.nextLine();
				}
			//	linenum++;
				continue;
			}
			tokens = line.split(at, -1);
			if(tokens.length < 3){
				System.out.println("Invalid Line");
				if(in.hasNextLine()){
				line = in.nextLine();
				}
				continue;
			}
			re = tokens[0];
			text = tokens[1];
			answer = tokens[2];
			

			// how does index of fail?
			start = answer.indexOf("[");
			if (start != -1) {
				answer = removeCharAt(answer, start);
			}
			end = answer.indexOf("]");
			if (end != -1) {
				answer = removeCharAt(answer, end);
			}

			shouldfind = true;

			if (start == -1 || end == -1) {
				shouldfind = false;
			}
			Regexp regexp = new Regexp(re);

			ret = regexp.match(text);
		//	System.out.println(linenum);

			if (ret != shouldfind || start != regexp.start()
					|| end != regexp.end()) {
				System.out.println(line);
			/*if (ret != shouldfind) {
					System.out.println("Shouldfind =" + shouldfind);
				}
				if (start != regexp.start()) {
					System.out.println("should start " + start);
					System.out.println("       start " + regexp.start());
					System.out.println();
				}
				if (end != regexp.end()) {
					System.out.println("should end " + end);
					System.out.println("       end " + regexp.end());
				}
				System.out.println();
*/
			}
			//linenum++;
		} while (in.hasNextLine());
	}

	// from ragnon.com
	private static String removeCharAt(String s, int pos) {
		StringBuffer buf = new StringBuffer(s.length() - 1);
		buf.append(s.substring(0, pos)).append(s.substring(pos + 1));
		return buf.toString();
	}
}