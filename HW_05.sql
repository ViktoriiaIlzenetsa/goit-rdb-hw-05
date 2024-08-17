USE hw_03;

-- 1. Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці orders відповідно для кожного поля запису з таблиці order_details.
	-- Це має бути зроблено за допомогою вкладеного запиту в операторі SELECT.

SELECT *, (SELECT customer_id FROM orders WHERE order_details.order_id = orders.id) AS customer_id
FROM order_details;

-- 2. Напишіть SQL запит, який буде відображати таблицю order_details. Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
	-- Це має бути зроблено за допомогою вкладеного запиту в операторі WHERE.

SELECT od.*, orders.shipper_id
FROM order_details od
LEFT JOIN orders ON od.order_id = orders.id
WHERE order_id IN (SELECT id FROM orders WHERE shipper_id = 3);

-- 3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою quantity>10 з таблиці order_details. Для отриманих даних знайдіть середнє значення поля quantity — групувати слід за order_id.

SELECT order_id, AVG(quantity)
FROM (SELECT * FROM order_details WHERE quantity>10) AS temp_table
GROUP BY order_id;

-- 4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp. Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит за аналогією до того, як це зроблено в конспекті.

WITH TemporalTable AS (
SELECT * 
FROM order_details 
WHERE quantity>10
)
SELECT order_id, AVG(quantity)
FROM TemporalTable
GROUP BY order_id;

-- 5. Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
	-- Використайте конструкцію DROP FUNCTION IF EXISTS. Застосуйте функцію до атрибута quantity таблиці order_details . Другим параметром може бути довільне число на ваш розсуд.
    
DROP FUNCTION IF EXISTS DividingTwoNumbers;

DELIMITER //

CREATE FUNCTION DividingTwoNumbers(divided FLOAT, divisor FLOAT)
RETURNS FLOAT 
DETERMINISTIC
NO SQL
BEGIN
	IF divisor = 0 THEN  
		RETURN NULL;
	ELSE 
		RETURN divided/divisor;
	END IF;
END//

DELIMITER ;

SELECT *, Round(DividingTwoNumbers(quantity, (SELECT SUM(quantity) FROM order_details))*100, 2) AS percent_of_total_quantity FROM order_details;




    
    