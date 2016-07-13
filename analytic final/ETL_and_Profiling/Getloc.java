package loc;
	
	import java.net.URLConnection;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.PrintStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathConstants;

import org.w3c.dom.Document;

	/**
	 * This class will get the lat long values.
	 Manish Reddy mc5410@nyu.edu
	 */
	public class Getloc
	{
	  public static void main(String[] args) throws Exception
	  {   
	      System.setProperty("java.net.useSystemProxies", "true");
	      String csvFile = "/home/cloudera/Desktop/zone_lookup.csv";
	      BufferedReader br = null;
	      String line = "";
			String cvsSplitBy = "[ ,]";
			String csv = "/home/cloudera/uber_14_final.csv";
		    final String COMMA_DELIMITER = ",";
		    final String NEW_LINE_SEPARATOR = "\n";
		    try {
				PrintStream out = new PrintStream(new FileOutputStream(csv));
				System.setOut(out);
				br = new BufferedReader(new FileReader(csvFile));
				
				while ((line = br.readLine()) != null) {
					

				        // use comma as separator
					String[] country = line.split(cvsSplitBy);
					Thread.sleep(1000);
					 String latLongs[] = getLatLongPositions(country[2]);
					 out.print(country[0]);
					 out.print(COMMA_DELIMITER);
					 out.print(latLongs[0]);
					 out.print(COMMA_DELIMITER);
					 out.print(latLongs[1]);
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

	  public static String[] getLatLongPositions(String address) throws Exception
	  {
	    int responseCode = 0;
	    String api = "http://maps.googleapis.com/maps/api/geocode/xml?address=" + URLEncoder.encode(address, "UTF-8") + "%20NY&sensor=true";
	    URL url = new URL(api);
	    HttpURLConnection httpConnection = (HttpURLConnection)url.openConnection();
	    httpConnection.connect();
	    responseCode = httpConnection.getResponseCode();
	    if(responseCode == 200)
	    {
	      DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();;
	      Document document = builder.parse(httpConnection.getInputStream());
	      XPathFactory xPathfactory = XPathFactory.newInstance();
	      XPath xpath = xPathfactory.newXPath();
	      XPathExpression expr = xpath.compile("/GeocodeResponse/status");
	      String status = (String)expr.evaluate(document, XPathConstants.STRING);
	      if(status.equals("OK"))
	      {
	         expr = xpath.compile("//geometry/location/lat");
	         String latitude = (String)expr.evaluate(document, XPathConstants.STRING);
	         expr = xpath.compile("//geometry/location/lng");
	         String longitude = (String)expr.evaluate(document, XPathConstants.STRING);
	         return new String[] {latitude, longitude};
	      }
	      else if(status.equals("OVER_QUERY_LIMIT")){
	    	  
	    	  Thread.sleep(10000);
	    	  String[] tok = new String[2];
	    	  tok[1] = "0";
	    	  tok[2] = "0";
	      }
	      else
	      {	 
	         throw new Exception("Error from the API - response status: "+status);
	         
	      }
	    }
	    return null;
	  }
	}


