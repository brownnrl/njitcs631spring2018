package edu.njit.cs631.fitness.data.projection;

import java.math.BigDecimal;

public class HourlyInstructorPayroll {

	public static final BigDecimal MINUTES_PER_HOUR = new BigDecimal(60);
	public static final String GET_HOURLY_INSTRUCTOR_PAYROLL_JPQL =     
			"select new " +
		    "   " + HourlyInstructorPayroll.class.getCanonicalName() + "(" +
		    "       i.id, " +
		    "       i.name, " +
		    "       i.wage, " +
		    "       INSTRUCTOR_HOURS_BY_TIME_INTERVAL(i.id, :beginning, :ending) " +
		    "   ) " +
		    "from HourlyInstructor i " +
		    "";
		    //"where p.createdOn > :fromTimestamp";
	
	public HourlyInstructorPayroll(Integer id, String name, BigDecimal hourlyWage, Integer minutes) {
		super();
		this.id = id;
		this.name = name;
		this.hourlyWage = hourlyWage;
		this.minutes = minutes;
	}


	public HourlyInstructorPayroll() {
		super();
	}
	
	private Integer id;
	private String name;
	private BigDecimal hourlyWage;
	private Integer minutes;
	
	public BigDecimal grossPay() {
		BigDecimal bigMinutes = new BigDecimal(minutes); 
		return hourlyWage.multiply(bigMinutes.divide(MINUTES_PER_HOUR));
	}
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public BigDecimal getHourlyWage() {
		return hourlyWage;
	}
	public void setHourlyWage(BigDecimal wage) {
		this.hourlyWage = wage;
	}
	public Integer getMinutes() {
		return minutes;
	}
	public void setMinutes(Integer minutes) {
		this.minutes = minutes;
	}


	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("HourlyInstructorPayroll [id=");
		builder.append(id);
		builder.append(", name=");
		builder.append(name);
		builder.append(", hourlyWage=");
		builder.append(hourlyWage);
		builder.append(", minutes=");
		builder.append(minutes);
		builder.append("]");
		return builder.toString();
	}

}
