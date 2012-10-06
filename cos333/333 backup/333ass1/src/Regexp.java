
public class Regexp {
	/**
	 * @param args
	 */
	private String regexp;
	private int relen;
	private int repos;
	private char char1;
	private char char2;
	private int start;
	private int end;
	private int stringpos;

	public Regexp(String re) {

		this.regexp = re;
		this.relen = regexp.length();
		this.repos = 0;
		this.stringpos = 0;
		if (this.relen >= 1) {
			this.char1 = this.regexp.charAt(0);
		}
		if (this.relen >= 2) {
			this.char2 = this.regexp.charAt(1);
		}
		this.start = -1;
		this.end = -1;
	}

	public boolean match(String s) // returns true if the regular expression
									// matches s, and false if not.
	{
		boolean ret;
		int index = 0;

		if (this.char1 == '^') {
			this.increment(1);
			ret = matchhere(s);
			if (ret == true) {
				this.start = 0;
			} else {
				this.start = -1;
				this.end = -1;
			}
			return ret;
		}

		do {
			ret = matchhere(s);
			if (ret == true) {
				start = index;
				return ret;
			} else {
				index++;
				s = s.substring(1);
				this.stringpos++;
			}
		} while (s.length() > 0);

		this.start = -1;
		this.end = -1;
		return false;

	}

	private boolean increment(int n) {
		assert (n <= 2);

		while ((this.repos + n) > this.relen) {
			n--;
		}

		if (n == 2) {
			this.char1 = this.regexp.charAt(this.repos + 1);
			this.char2 = this.regexp.charAt(this.repos + 2);
			this.repos += 2;
			return true;
		} else if (n == 1) {
			this.char1 = this.regexp.charAt(this.repos + 1);
			this.char2 = '\0';
			this.repos++;
			return false;
		} else if (n == 0) {
			this.char1 = '\0';
			this.char2 = '\0';
			return false;
		}
		return false;
	}

	private boolean matchhere(String s) {
		if (this.char2 == '*') {
			return matchstar(s);
		}
		if (this.char2 == '?') {
			return matchqmark(s);
		}
		if (this.char2 == '+') {
			return matchplus(s);
		}
		// TODO: account for possibility of dollarsign in char2
		if (this.char1 == '$' && (repos + 1 == relen)) {
			if (s.length() == 0) {
				end = this.stringpos;
				return true;
			}
		}

		if (s.length() != 0 && (this.char1 == '.' || s.charAt(0) == this.char1)) {
			this.stringpos++;
			return matchhere(s.substring(1));
		}
		return false;
	}

	private boolean matchstar(String s) {

		assert (this.char2 == '*');

		boolean ret;
		char c = s.charAt(0);
		int i;

		// should c=s.charAt(i) be increment condition?
		for (i = 0; i < s.length() && (c == this.char1 || this.char1 == '.'); i++) {
			c = s.charAt(i);
		}
		do {
			// increment before matchhere?
			ret = matchhere(s.substring(i));
			if (ret == true) {
				this.stringpos += i;
				this.increment(2);
				return ret;
			}
		} while (i-- > 0);

		return false;
	}

	private boolean matchplus(String s) {

		assert (this.char2 == '+');

		int i;
		char c;
		String copy = s;
		boolean ret;

		if (s.length() == 0) {
			return false;
		}

		if (s.charAt(0) != this.char1 && this.char1 != '.') {
			return false;
		}

		this.stringpos++;
		copy = s.substring(1);

		c = copy.charAt(0);

		for (i = 0; i < copy.length() && (c == this.char1 || this.char1 == '.'); i++) {
			c = s.charAt(i);
		}
		do {
			// increment before matchhere?
			ret = matchhere(s.substring(i));
			if (ret == true) {
				this.stringpos += i;
				this.increment(2);
				return ret;
			}
		} while (i-- > 0);
		return false;

	}

	private boolean matchqmark(String s) {
		assert (this.char2 == '?');

		boolean ret;

		if (s.length() == 0) {
			return matchhere(s);
		}
		// TODO: does order matter?
		// increment before matchhere?
		// matches 0
		ret = matchhere(s);

		if (ret == false) {
			if (s.charAt(0) == this.char1 || this.char1 == '.') {
				this.stringpos++;
				ret = matchhere(s.substring(1));
				if (ret == true) {
					// increment before matchhere?
					this.increment(2);
				}
				return ret;
			}
		}

		return false;

	}

	public int start() // returns the index of the first character of the
						// matched substring, or -1 if there was no match.
	{
		return this.start;

	}

	public int end() // returns the index of one beyond the last character of
						// the matched substring, or -1 if there was no match.
	{
		return this.end;
	}

}
