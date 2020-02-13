CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno,deptno);
CREATE INDEX idx_n_emp_011 ON emp (deptno, sal);

CREATE INDEX idx_dept_01 ON dept (deptno,loc);

EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE empno = :empno;

SELECT *
FROM TABLE (dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM dept
WHERE deptno = :deptno;

SELECT *
FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.deptno LIKE :deptno || '%';

SELECT *
FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno = :deptno
AND d.loc = :loc;

SELECT *
FROM TABLE(dbms_xplan.display);