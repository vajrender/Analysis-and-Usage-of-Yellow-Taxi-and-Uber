package combine;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;


public class lookup {
	
	public static void main(String args[]){
	/* Manish Reddy mc5410@nyu.edu */
		
		lookup obj = new lookup();
		try {
			obj.run();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public void run() throws IOException {

		String csvFile = "/Users/Manish/Desktop/june-sep15.csv";
		String zonelook = "/Users/Manish/Desktop/zone_lookup.csv";
		BufferedReader br = null;
		BufferedReader br1 = null;
		String line = "";
		String cvsSplitBy = "[ ,]";
		String csv = "/Users/Manish/Desktop/workbook3.csv";
	    final String COMMA_DELIMITER = ",";
	    final String NEW_LINE_SEPARATOR = "\n";

	     
		try {
			PrintStream out = new PrintStream(new FileOutputStream(csv));
			System.setOut(out);
			br = new BufferedReader(new FileReader(csvFile));
			
			while ((line = br.readLine()) != null) {
				

			        // use comma as separator
				String[] country = line.split(cvsSplitBy);
				

				 out.print(country[1]);
				 out.print(COMMA_DELIMITER);
				 out.print(country[2]);
				 out.print(COMMA_DELIMITER);
				 out.print(country[4]);
				 out.print(NEW_LINE_SEPARATOR);

			}
			out.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

}
}
