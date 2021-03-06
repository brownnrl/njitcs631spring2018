package edu.njit.cs631.fitness.config;

import java.util.Locale;
import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

@Configuration
@EnableJpaRepositories(basePackages = {"edu.njit.cs631.fitness.data.entity",
                                       "edu.njit.cs631.fitness.data.entity.security",
                                       "edu.njit.cs631.fitness.data.projection",
                                       "edu.njit.cs631.fitness.data.repository",
                                       "edu.njit.cs631.fitness.data.repository.security",
                                       "edu.njit.cs631.fitness.service.api",
                                       "edu.njit.cs631.meidcal.service.impl"
                                       })
@ComponentScan({"edu.njit.cs631.fitness.web.controller",
	            "edu.njit.cs631.fitness.service",
                "edu.njit.cs631.fitness.service.api",
                "edu.njit.cs631.fitness.service.impl",
                "edu.njit.cs631.fitness.data.manager"})
public class MainConfig {

	// you can use string constants in annotations, but not array constants
    private static final String[] JPA_PACKAGES = {
    		"edu.njit.cs631.fitness.data.entity",
            "edu.njit.cs631.fitness.data.entity.security",
            "edu.njit.cs631.fitness.data.projection",
            "edu.njit.cs631.fitness.data.repository",
            "edu.njit.cs631.fitness.data.repository.security",
            "edu.njit.cs631.fitness.service.api",
            "edu.njit.cs631.meidcal.service.impl"
            };

	public MainConfig() {
        super();
    }

    @Autowired
    private Environment env;

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        final LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource());
        em.setPackagesToScan(JPA_PACKAGES);
        final HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(vendorAdapter);
        em.setJpaProperties(additionalProperties());
        return em;
    }

    @Bean
    public DataSource dataSource() {
        final DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName(env.getProperty("spring.datasource.driver-class-name"));
        dataSource.setUrl(env.getProperty("spring.datasource.url"));
        dataSource.setUsername(env.getProperty("spring.datasource.username"));
        dataSource.setPassword(env.getProperty("spring.datasource.password"));
        return dataSource;
    }

    @Bean
    public JpaTransactionManager transactionManager() {
        final JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(entityManagerFactory().getObject());
        return transactionManager;
    }

    @Bean
    public PersistenceExceptionTranslationPostProcessor exceptionTranslation() {
        return new PersistenceExceptionTranslationPostProcessor();
    }
    @Bean
	public LocaleResolver localeResolver() {
	    SessionLocaleResolver slr = new SessionLocaleResolver();
	    slr.setDefaultLocale(Locale.US);
	    return slr;
	}
	
	@Bean
	public LocaleChangeInterceptor localeChangeInterceptor() {
	    LocaleChangeInterceptor lci = new LocaleChangeInterceptor();
	    lci.setParamName("lang");
	    return lci;
	}

    protected Properties additionalProperties() {
        final Properties hibernateProperties = new Properties();
        hibernateProperties.setProperty("hibernate.hbm2ddl.auto", env.getProperty("hibernate.hbm2ddl.auto"));
        hibernateProperties.setProperty("hibernate.dialect", env.getProperty("hibernate.dialect"));
        return hibernateProperties;
    }


}
