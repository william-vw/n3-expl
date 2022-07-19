package wvw.xai;

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
		N3ModelSpec spec = N3ModelSpec.get(Types.N3_MEM_FP_INF);
		spec.setFeedback(new N3Feedback(N3MistakeTypes.BUILTIN_WRONG_INPUT, FeedbackTypes.WARN, FeedbackActions.LOG));

		N3Model model = ModelFactory.createN3Model(N3ModelSpec.get(Types.N3_MEM_FP_INF));

		model.read(IOUtils.getResourceInputStream(Explainer.class, "proofs/copd_red1.ttl"), "N3");
		
		model.read(IOUtils.getResourceInputStream(Explainer.class, "rules/describe.n3"), "N3");
		model.listStatements(null, model.createResource("http://wvw.org/xai#description"), (Resource) null)
				.forEachRemaining(stmt -> {
					System.out.println(stmt.getSubject() + " - " + stmt.getObject());
				});
		System.out.println();
		
		model.read(IOUtils.getResourceInputStream(Explainer.class, "rules/html.n3"), "N3");
		model.listStatements(null, model.createResource("http://wvw.org/xai#output"), (Resource) null)
				.forEachRemaining(stmt -> {
					System.out.println(stmt.getSubject() + " ? " + stmt.getObject());
				});

//		model.write(System.out);
//		model.getDeductionsModel().write(System.out);
	}
}
