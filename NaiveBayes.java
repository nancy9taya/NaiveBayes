package naiveBayes;
import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class NaiveBayes {


public static class trainMapper extends Mapper<LongWritable,Text, Text, IntWritable> {
    private Text reduceKey;
    private final static IntWritable ONE=new IntWritable(1);
   @Override 
    public void map(LongWritable key,Text value,Context context)throws IOException, InterruptedException {
        String[] tokens=value.toString().split(",");
        int classIndex=tokens.length-1;
        String theClass=tokens[classIndex];
        for(int i=0;i<classIndex;i++){
            reduceKey=new Text(tokens[i]+","+theClass+",");
            
            context.write(reduceKey,ONE);
          
        }
        reduceKey=new Text("CLASS,"+theClass+",");

        context.write(reduceKey,ONE);

    }
}

public static class trainReducer extends Reducer<Text, IntWritable, Text,IntWritable> {
@Override 
    public void reduce(Text key,Iterable<IntWritable> values,Context context)throws IOException, InterruptedException {
        int total=0;
        for(IntWritable value:values){
            total+=value.get();
        }

        context.write(key,new IntWritable(total));

    }
}
public static void main(String[] args) throws Exception {
	  Configuration conf = new Configuration();
	  Job job = Job.getInstance(conf, "NaiveBayes");
	  job.setJarByClass(NaiveBayes.class);
	  job.setMapperClass(trainMapper.class);
	  job.setCombinerClass(trainReducer.class);
	  job.setReducerClass(trainReducer.class);
	  job.setOutputKeyClass(Text.class);
	  job.setOutputValueClass(IntWritable.class);
	  FileInputFormat.addInputPath(job, new Path(args[0]));
	  FileOutputFormat.setOutputPath(job, new Path(args[1]));
	  System.exit(job.waitForCompletion(true) ? 0 : 1);
	}





}


