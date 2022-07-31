package wvw.xai;

import java.io.File;

import org.apache.jen3.n3.FeedbackActions;
import org.apache.jen3.n3.FeedbackTypes;
import org.apache.jen3.n3.N3Feedback;
import org.apache.jen3.n3.N3MistakeTypes;
import org.apache.jen3.n3.N3Model;
import org.apache.jen3.n3.N3ModelSpec;
import org.apache.jen3.n3.N3ModelSpec.Types;
import org.apache.jen3.rdf.model.ModelFactory;
import org.apache.jen3.rdf.model.Resource;
import org.apache.jen3.util.IOUtils;

public class Explainer {

	public static void main(String[] args) throws Exception {
//		test();
		explain();
	}

	protected static void test() throws Exception {
		N3ModelSpec spec = N3ModelSpec.get(Types.N3_MEM_FP_INF);
		spec.setFeedback(new N3Feedback(N3MistakeTypes.BUILTIN_WRONG_INPUT, FeedbackTypes.WARN, FeedbackActions.LOG));

		N3Model model = ModelFactory.createN3Model(N3ModelSpec.get(Types.N3_MEM_FP_INF));
		model.read(IOUtils.getResourceInputStream(Explainer.class, "cases/diabetes/case1/test_jen3.n3"), "N3");

		model.getDeductionsModel().write(System.out);
	}

	// replace-all: @forAll (var:[^\{]*) -> ""
	protected static void explain() throws Exception {
		String proofType = "swap";
		String system = "jen3";

//		String proofFile = "patient_red1.ttl";
//		String labelFile = null;

		String proofFile = "diabetes_case2.ttl";
		String labelFile = "cases/diabetes/labels.ttl";

		N3ModelSpec spec = N3ModelSpec.get(Types.N3_MEM_FP_INF);
		spec.setFeedback(new N3Feedback(N3MistakeTypes.BUILTIN_WRONG_INPUT, FeedbackTypes.NONE, FeedbackActions.LOG));

		N3Model model = ModelFactory.createN3Model(spec);

		if (labelFile != null)
			model.read(IOUtils.getResourceInputStream(Explainer.class, labelFile), "N3");

		model.read(IOUtils.getResourceInputStream(Explainer.class, "proofs/" + proofType + "/" + proofFile), "N3");

		String explainFolder = "explain/" + proofType + "/" + system + "/";
		model.read(IOUtils.getResourceInputStream(Explainer.class, explainFolder + "describe.n3"), "N3");
		model.read(IOUtils.getResourceInputStream(Explainer.class, explainFolder + "collect.n3"), "N3");

//		model.listStatements(null, model.createResource("http://wvw.org/xai#description"), (Resource) null)
//				.forEachRemaining(stmt -> {
//					System.out.println(stmt.getSubject() + " - " + stmt.getObject());
//				});
//		System.out.println();
//
//		model.listStatements(null, model.createResource("http://wvw.org/xai#conclusionStr"), (Resource) null)
//				.forEachRemaining(stmt -> {
//					System.out.println(stmt.getSubject() + " => " + stmt.getObject());
//				});
//		System.out.println();
//
//		model.listStatements(null, model.createResource("http://wvw.org/xai#output"), (Resource) null)
//				.forEachRemaining(stmt -> {
//					System.out.println(stmt.getSubject() + " ? " + stmt.getObject());
//				});
//		System.out.println();

		String html = model.outputString();
//		System.out.println(html);
		
		String resDir = System.getProperty("user.dir") + "/src/main/resources/";
		String htmlDir = resDir + "output/jen3/";
		
		String fileName = proofFile.substring(0, proofFile.indexOf(".ttl"));
		File htmlFile = new File(htmlDir + fileName + ".html");
		IOUtils.writeToFile(html, htmlFile);
		System.out.println("written to " + htmlFile.getAbsolutePath());
		
//		model.write(System.out);
		model.getDeductionsModel().write(System.out);
	}
}