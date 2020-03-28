// Wed Dec 17 16:41:25 CET 2014
// Karl Kastner, Berlin

public class JCentreline
{
//	double dummy;
	private Qtree2 qtree;
//	private X
	private int    [] seg;
	private double [] seg_S;
	private int    [][] seg_id;
	private int    [][] seg_node;
	private double [][] node_D;
	
// Qtree qtree, // final double [] X, final double [] Y,

	public JCentreline( final Qtree2 qtree, // final double [] X, final double [] Y,
		final  int [] seg,
		final  double [] seg_S,
		final  int [][] seg_id,
		final int seg_node[][],
		final  double node_D[][])
	{
	//	this.qtree    = Qtree(X,Y);
		this.qtree    = qtree;
		this.seg      = seg;
		this.seg_S    = seg_S;
		this.seg_id   = seg_id;
		this.seg_node = seg_node;
		this.node_D = node_D;
	} // constructor

	// TODO THIS is actually mindx and not segment andymore, 
	//      mindx and S_seg, should use s-n transform here
	public int segment(final double x0, final double y0)
	{
		int    [][] Nkey = new int[1][1];
		double [][] Dmin = new double[1][1];
		double [] X = new double[1];
		double [] Y = new double[1];
		X[0] = x0;
		Y[0] = y0;
		qtree.nearest_neighbour(X, Y, Nkey, Dmin);
//		d2 = dist2(X0,Y0,X,Y);
//		[d2 mindx] = min(d2);
		int mindx = Nkey[0][0];
//		int segdx = seg[mindx-1];
		//S     = seg_S(mindx);
		//d1    = abs(seg_S(mindx) - seg_S(seg_id(segdx,1)));
		//d2    = abs(seg_S(mindx) - seg_S(seg_id(segdx,2)));
//		return segdx;
		return mindx;
	} // segment

	public double [][] distance(final double [] x0, final double [] y0,
			final double [] x1, final double [] y1,
			final boolean symmetric)
	{
		double [][] D = new double[x0.length][x1.length];
		if (symmetric)
		{
			for (int i=0; i<x0.length; i++)
			{
			for (int j=i+1; j<x1.length; j++)
			{
				D[i][j] = distance(x0[i],y0[i],x1[j],y1[j]);
				D[j][i] = D[i][j];
			} // for j
			} // for i
		} else {
		for (int i=0; i<x0.length; i++)
		{
		for (int j=0; j<x1.length; j++)
		{
			D[i][j] = distance(x0[i],y0[i],x1[j],y1[j]);
		} // for j
		} // for i
		}
		return D;
	} // distance()

	public double distance(final double x0, final double y0,
			final double x1, final double y1)
	{
		int mindx  = segment(x0,y0);
		if (mindx < 1)
		{
			return Double.NaN;
		}
//		System.out.println(mindx);
		int    s1  = seg[mindx-1];
//		System.out.println(s1 + " " + seg_S.length + " " + seg_id.length);
		double dl1 = Math.abs(seg_S[mindx-1] - seg_S[seg_id[s1-1][0]-1]);
		double dr1 = Math.abs(seg_S[mindx-1] - seg_S[seg_id[s1-1][1]-1]);
		double S1  = seg_S[mindx-1];

		mindx  = segment(x1,y1);
		if (mindx < 1)
		{
			return Double.NaN;
		}
		int    s2  = seg[mindx-1];
		double dl2 = Math.abs(seg_S[mindx-1] - seg_S[seg_id[s2-1][0]-1]);
		double dr2 = Math.abs(seg_S[mindx-1] - seg_S[seg_id[s2-1][1]-1]);
		double S2  = seg_S[mindx-1];
		
		double d;
		double d_min;
		if (s1 == s2)
		{
			d_min = Math.abs(S1 - S2);
		} else {
			d_min = Double.POSITIVE_INFINITY;
		}

		// left-left
		d = node_D[seg_node[s1-1][0]-1][seg_node[s2-1][0]-1] + dl1 + dl2;
		d_min = Math.min(d_min,d);
		// left-right
		d = node_D[seg_node[s1-1][0]-1][seg_node[s2-1][1]-1] + dl1 + dr2;
		d_min = Math.min(d_min,d);
		// right-left
		d = node_D[seg_node[s1-1][1]-1][seg_node[s2-1][0]-1] + dr1 + dl2;
		d_min = Math.min(d_min,d);
		// right-right
		d = node_D[seg_node[s1-1][1]-1][seg_node[s2-1][1]-1] + dr1 + dr2;
		d_min = Math.min(d_min,d);
			
		return d_min;	
	} // distance
} // JCentreline

