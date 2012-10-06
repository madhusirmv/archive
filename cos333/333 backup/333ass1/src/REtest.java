import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class REtest {

	public static void main(String[] args) {
		try {
			System.setIn(new FileInputStream("/home/pgrabowski/phdvdev/workspace/333ass1/src/re.txt"));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Scanner in = new Scanner(System.in);

		String line = in.nextLine();
		String at = "[@]";
		String[] tokens;
		String re;
		String text;
		String answer;
		int start, end;
		boolean ret, shouldfind;

		start = 0;
		end = 0;

		do {
			tokens = line.split(at);
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

			if (ret != shouldfind || start != regexp.start()
					|| end != regexp.end()) {
				System.out.println(line);
			}
			line = in.nextLine();

		}while (in.hasNextLine());
	}

	// from ragnon.com
	public static String removeCharAt(String s, int pos) {
		StringBuffer buf = new StringBuffer(s.length() - 1);
		buf.append(s.substring(0, pos)).append(s.substring(pos + 1));
		return buf.toString();
	}
}