--tb_emp 테이블 생성


CREATE TABLE tb_emp(
        e_no NUMBER PRIMARY KEY,
        e_nm VARCHAR2(50) NOT NULL,
        g_cd VARCHAR2(20) NOT NULL,  
        j_cd VARCHAR2(20) NOT NULL,
        d_cd VARCHAR2(20) NOT NULL,
        CONSTRAINT tb_grade_tb_emp FOREIGN KEY (g_cd) REFERENCES tb_grade (g_cd),
        CONSTRAINT tb_dept_tb_emp FOREIGN KEY (d_cd) REFERENCES tb_dept (d_cd),
        CONSTRAINT tb_job_tb_emp FOREIGN KEY (j_cd) REFERENCES tb_job (j_cd));




--tb_grade 테이블 생성
CREATE TABLE tb_grade(
        g_cd VARCHAR2(20) PRIMARY KEY,
        g_nm VARCHAR2(50) NOT NULL,
        ord NUMBER);

--tb_dept
CREATE TABLE tb_dept(
        d_cd VARCHAR2(20) PRIMARY KEY,
        d_nm VARCHAR2(50) NOT NULL,
        p_d_cd VARCHAR2(20));
        
CREATE TABLE tb_job(
        j_cd VARCHAR2(20) PRIMARY KEY,
        j_nm VARCHAR2(50) NOT NULL,
        ord NUMBER);
        

--tb_cs_cd
CREATE TABLE tb_cs_cd(
        cs_cd VARCHAR2(20) PRIMARY KEY,
        cs_nm VARCHAR2(50) NOT NULL,
        p_cs_cd VARCHAR2(20));
        
--tb_counsel
CREATE TABLE tb_counsel(
        cs_id VARCHAR(20) PRIMARY KEY,
        cs_reg_dt DATE NOT NULL,
        cs_cont VARCHAR2(4000) NOT NULL,
        e_no NUMBER NOT NULL REFERENCES tb_emp (e_no),
        cs_cd1 VARCHAR2(20) NOT NULL REFERENCES tb_cs_cd (cs_cd),
        cs_cd2 VARCHAR2(20) REFERENCES tb_cs_cd (cs_cd),
        cs_cd3 VARCHAR2(20) REFERENCES tb_cs_cd (cs_cd));
        
--tb_dept 제약조건 추가
ALTER TABLE tb_dept ADD CONSTRAINT tb_dept_tb_dept FOREIGN KEY (p_d_cd) REFERENCES tb_dept (d_cd); 

--tb_cs_cd
ALTER TABLE tb_cs_cd ADD CONSTRAINT tb_cs_cd_tb_cs_cd FOREIGN KEY (p_cs_cd) REFERENCES tb_cs_cd(cs_cd);