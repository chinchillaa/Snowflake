# 

🥋 Create a Database

### 

**🥋 Log in to your Snowflake Trial**

When you activated your account it would have opened your trial in a new browser tab, but just in case you closed that tab or lost track of it, remember you can always go back to your email inbox and find an email that will give you the link to your Snowflake Trial account.

**This trial account is where you'll be doing ALL YOUR LAB WORK for this workshop.**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_004.jpg)

### 

**🥋 Create a New Database**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_006.png)

NOTE: The Sandbox_DB and Sandbox_WH are new additions to Trial Accounts that began for some accounts in early 2025.

**If you do not see a Sandbox database or warehouse, do not worry. It is not vital to have them. Just proceed without them.**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_007.png)

[  
](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/index.html#/lessons/Kf8tFKl8UPyYkKWfKswuXCNECxpldOBI)

# 

🥋 Explore Your New Database

### 

**🥋 Explore the Database You Created**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_011.png)

- How many schemas are included in your database?
    
- What are the names of the schemas?
    
- What is inside each of the schemas? Are there lots of objects, just a few, or none?
    

### 

**📓 Organizing Database Objects**

Databases are used to group datasets (tables) together. A second-level organizational grouping, within a database, is called a schema.

Every time you create a database, Snowflake will automatically create two schemas for you.

The INFORMATION_SCHEMA schema holds a collection of views.  The INFORMATION_SCHEMA schema cannot be deleted (dropped), renamed, or moved.

The PUBLIC schema is created empty and you can fill it with tables, views and other things over time. The PUBLIC schema can be dropped, renamed, or moved at any time.  

Requires a correct answer to continue

When you created your DEMO_DB database, what two schemas were created for you?  

Select 2 answers:

- INFORMATION_SCHEMA
    
- METADATA_SCHEMA
    
- PLEBEIANS
    
- PUBLIC
    

SUBMIT

  

Requires a correct answer to continue

Which role is listed as the OWNER role of the DEMO_DB database Tsai created?

ACCOUNTADMIN

SECURITYADMIN

SYSADMIN

USERADMIN

SUBMIT

# 

🥋 Transfer Ownership of Your New Database

### 

**🥋 Transfer Ownership of Your Database to the SYSADMIN Role**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_013.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_014.jpg)

Requires a correct answer to continue

Which of the following statements seem true about database ownership?

Select 4 answers:

- SYSADMIN owns the database now.
    
- SECURITYADMIN owns the database now.
    
- ACCOUNTADMIN owns the SYSADMIN role, so it has ownership rights also, but indirectly.
    
- ACCOUNTADMIN owned the database originally because it was the role setting during database creation.
    
- SECURITYADMIN owned the database originally because it was the role setting during database creation.
    
- We can transfer ownership of a database to a different role, after it has been created.
    

SUBMIT

  

### 

**🥋 Switch Your System Role Back to SYSADMIN**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_008.png)

# 

🎭 Identity vs. Access

Requires a correct answer to continue

Check all that are true about IDENTITY:

Select 3 answers:

- Passing an identity check is called Authorization.
    
- Passing an identity check is called Authentication.
    
- Identity is about WHAT you can see/do.
    
- Identity is about WHO you are.
    
- Identity is sometimes tested and proven through username and password combinations.
    
- Identity is sometimes tested and proven through RBAC role assignments.
    

SUBMIT

  

Requires a correct answer to continue

Check all that are true about ACCESS.

Select 3 answers:

- Proving a right to access something is called Authorization.
    
- Proving a right to access something is called Authentication.
    
- Access is about WHAT you can see/do.
    
- Access is about WHO you are.
    
- Access is sometimes tested and awarded through username and password combinations.
    
- Access is sometimes tested and awarded through RBAC role assignments.
    

SUBMIT

# 

🥋 Changing Your Role Setting

### 

**🥋 Learning About Snowflake System Roles**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_016.png)

Use the Roles diagram to explore the roles that have been assigned to you. Notice that in the diagram, some roles are linked to others in what looks like an org chart or family tree. This is because some roles get subsets of rights from other roles.

### 

**Role Creation as Inheritance**

[When Thierry and Benoit were first setting up Snowflake ROLES in Benoit's apartment(opens in a new tab)](https://www.youtube.com/watch?v=Y05ZNHwvfsg)  they created the all-powerful ACCOUNTADMIN. Then, like a parent, giving some DNA to one child and some DNA to another, they set up system ROLES like SECURITYADMIN and SYSADMIN.

In this way, when ROLES are first designed, there is the idea of setting up different "children" to inherit from "parents" just as you might dole out DNA, or assets in a Last Will and Testament.

# 

📓 RBAC Review

### 

**🎭 RBAC Review**

Requires a correct answer to continue

Which of the options below are in the same tree or chart as ACCOUNTADMIN?

Select 3 answers:

- TYANG
    
- PUBLIC
    
- ORGADMIN
    
- SYSADMIN
    
- SECURITYADMIN
    
- USERROLE
    
- USERADMIN
    

SUBMIT

  

Requires a correct answer to continue

Trial account users are awarded a high-powered role and inherit several others. Which of the statements below are true?

Select 2 answers:

- When you sign up for a trial, you are directly awarded the ACCOUNTADMIN user role.
    
- When you sign up for a trial, you get the ACCOUNTADMIN role via inheritance.
    
- When you sign up for a trial, you are directly awarded the SECURITYADMIN user role.
    
- When you sign up for a trial, you get the SECURITYADMIN role via inheritance.
    

SUBMIT

  

Requires a correct answer to continue

If you see a "does not exist" error in Snowflake, what is the first thing you should check?

Your Account

Your Username

Your Role

SUBMIT

# 

🎭 DAC Model & Default Role

### 

**🎭 What is DAC?**

### 

**📓 Discretionary Access Control (DAC)**

Beyond RBAC, there is another facet of Snowflake's access model called Discretionary Access Control (DAC), which means "you create it, you own it." If SYSADMIN creates a database, they own it and so they can delete it, change the name, and more.  

We see DAC models when we create an MS Word Doc, an email or a Google Sheets document. We created it, so we own it. We created it, so we can delete it! We created it, so we can rename it!

Because of the combination of RBAC and DAC in Snowflake, when we create something, the ROLE we were using at the time we created it, is the role that OWNS it.

Requires a correct answer to continue

Select all statements that are true about Snowflake's Access Control Model.

Select 4 answers:

- Snowflake uses Role-based Access Control (RBAC)
    
- Snowflake uses Discretionary Access Control (DAC)
    
- In Snowflake, rights and privileges are awarded to USERS
    
- In Snowflake, OWNERSHIP of items belongs to USERS
    
- In Snowflake, rights and privileges are awarded to ROLES
    
- In Snowflake, OWNERSHIP of items belongs to ROLES
    

SUBMIT

  

### 

**📓 Default Role Assignment**

Totally unrelated to any other rules of ROLE design, hierarchy, inheritance, BOGO, or custodial oversight, there is the concept of a DEFAULT ROLE. This is a USER setting that is designed for convenience.

Each USER has a role assigned as their default. The default role that has been assigned to you as a Trial Account User is the ACCOUNTADMIN role. This just means that each time you log in to Snowflake, your role will be set to ACCOUNTADMIN.

You can change your default role to something different but we don't recommend you do that for your trial account because we have written the workshop labs with the presumption that you will use ACCOUNTADMIN for most tasks.

Requires a correct answer to continue

How does the default role affect your Snowflake work?

You can never use any other role in Snowflake except your default. You can see the other roles but you can't really use them

The default role is the only role that you can use to create objects, but you can use other roles to run SELECT statements

If you change your system role to another role, when you log out and log back in, your role will revert to the default

SUBMIT

# 

🎯 Ownership Challenge Lab!

### 

**🎯 Challenge Lab!!**

This is a Challenge Lab! Challenge Labs are different from other labs because we don't give you the step-by-step instructions. Instead, we give you the end goal and expect you to use the skills you learned in earlier labs to complete the work. **Challenge labs are required.**

Good Luck!

### 

**🎯 Give SYSADMIN "Access" to the PUBLIC Schema**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_018.jpg)

The PUBLIC schema seems to be missing, but is it REALLY missing? Or is your current role of SYSADMIN causing you to lose access to it? Update the PUBLIC schema so that it can be seen and used by the SYSADMIN role. It is possible to give "access" a variety of ways, but since this is a beginner-level course, we want you to use OWNERSHIP to make the schema visible to, and usable by the SYSADMIN role. Ownership is the simplest way to give access and is fine for our needs in this course. Another way is called "GRANTING PRIVILEGES" but we do not cover that in this course.

**HINT:** You'll need to switch back to ACCOUNTADMIN so that you can make the change. Also, each time you change roles, you should probably do a browser refresh, just to make sure you're seeing the access of your current role.

When SYSADMIN can see both schemas, click the CONTINUE button below.

# 

🎯 Role, Creation, & Ownership Challenge Lab!

### 

**🎯 Create a New Database Called UTIL_DB**

Create a new database and name it UTIL_DB. This database and the PUBLIC schema should be owned by SYSADMIN.

**HINT:** If you set your role to SYSADMIN before you create the database, it will automatically be owned by SYSADMIN. You won't have to do any transfers of ownership. If you forget to set your role to SYSADMIN before creating the UTIL_DB, you will need to transfer ownership to SYSADMIN.

### 

**🥅  Does Your Databases Page Look Like This, Now?**

It should.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_020.png)

If your databases page doesn't look like the image shown above, review previous lesson labs and fix any ownership issues. When you have confirmed your databases, click the CONTINUE button below.

# 

📓 Roles and Warehouse Visibility

### 

**📓 Warehouses in Your Trial Account**

In Snowflake, data is held in databases and any processing of data is done by something called a "warehouse." The terminology is a little odd. Most people who work in the data field think of a warehouse as a special kind of database, not as a compute engine. Only Snowflake calls computing engines "warehouses."

Regardless of the terminology, when your trial account was created, three compute resources (a.k.a "warehouses") were created for you.

One is called **COMPUTE_WH**. It's owned by ACCOUNTADMIN.  You will use the COMPUTE_WH warehouse to do your lab work in this workshop.

The second is called **SNOWFLAKE_LEARNING_WH**, also owned by ACCOUNTADMIN.  This is a default warehouse granted to new accounts, and we won't use it in this course.

A third warehouse is called **SYSTEM$STREAMLIT_NOTEBOOK_WH**. That warehouse will be used by Snowflake to do any work required by streamlit apps and notebooks you create and run. You will not use this warehouse directly, only Snowflake will use it, on your behalf.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_022.png)

### 

**🎯 CHALLENGE LAB: Make the Warehouse Available to SYSADMIN**

There are different ways to make a compute resource available to different roles, but as we saw with databases, sometimes the easiest way to grant access is to transfer ownership to a lower role.  Since the ACCOUNTADMIN role is in the same tree as the SYSADMIN role, ACCOUNTADMIN will still have access to the warehouse, even if SYSADMIN is the owner.

Transfer the COMPUTE_WH warehouse to SYSADMIN.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_023.png)

# 

🏁 Summary & Next Steps

Requires a correct answer to continue

Imagine that you create a database while your role is set to ACCOUNTADMIN.

Later, you transfer the database ownership to SYSADMIN.

Then, you get an error saying the PUBLIC Schema DOES NOT EXIST.

What **SEQUENCE** of steps should you take if you want to access the PUBLIC schema while in the SYSADMIN role?

Select 4 answers:

- Step 1) Change your role to ACCOUNTADMIN and refresh the browser
    
- Step 2) Transfer ownership of the database back to ACCOUNTADMIN
    
- Step 2) Navigate to the PUBLIC schema
    
- Step 3) Create a new schema called SA_PUBLIC
    
- Step 3) Transfer the ownership of the PUBLIC schema to SYSADMIN
    
- Step 4) Change your role to SYSADMIN and refresh the browser
    
- Step 4) Delete your USER.
    

SUBMIT

  

### 

**🏁 Are You Ready for Lesson 3?**

If you:

- Can switch between roles on the HOME page
    
- Can see the COMPUTE_WH warehouse while in the SYSADMIN role
    
- Can see your DEMO_DB database when your role is set to SYSADMIN
    
- Can see your UTIL_DB database when your role is set to SYSADMIN
    
- Can name the first rule of troubleshooting in Snowflake ("Check your ____")
    

You are ready for Lesson 3!

# 

🪴 Uncle Yer's Plant Shop

### 

**🎭 Uncle Yer's Plant Shop**

Requires a correct answer to continue

Uncle Yer initially moved his data from paper to what kind of software?

Word Processing software

Spreadsheet software

HTML software

Learning software

SUBMIT

  

Requires a correct answer to continue

Uncle Yer embraced the new data system by teaching himself to use what?

Spreadsheet functions like UPPER

SQL functions like TRIM

SQL commands like UPDATE

Word functions for pagination

SUBMIT

  

Requires a correct answer to continue

Tsai worried that shifting Uncle Yer's data to database software would cause what issues?

Select 2 answers:

- Uncle Yer would feel guilty about leaving spreadsheets behind after so much effort learning them
    
- Uncle Yer might find database concepts too difficult
    
- Uncle Yer would not want to pay the expensive up-front costs for a traditional database system license
    
- Uncle Yer doesn't like new technology and would want to stick with what he already knows
    

SUBMIT

  

Requires a correct answer to continue

Tsai decides to teach Uncle Yer to use Snowflake for what 3 reasons?

- Snowflake has awesome, free courses to help learners get started easily.
    
- Snowflake has a simplified UI designed to help learners focus effectively during the learning process.
    
- Snowflake does not require an up-front purchase. Instead, it has free trial credits and then converts to a pay-as-you-go model.
    

SUBMIT

# 

🎯 Set Up Uncle Yer's Database & Schemas

### 

**🎯 Uncle Yer Needs a Database and some Schemas**

1. Set your role to **SYSADMIN**.
    
2. **Create** a Database and name it **GARDEN_PLANTS**.
    
3. **Drop** the **PUBLIC** schema that was automatically created when you created your GARDEN_PLANTS database.
    
4. **Create** three new schemas in your GARDEN_PLANTS database. Name them **VEGGIES**, **FRUITS** and **FLOWERS**.
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_027.jpg)

**NOTE**: "Drop" is the same as "Delete."

When this Challenge Lab is complete, your account should look like this:

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_029.png)

# 

🥋 Create an Worksheet & Run Some Code

### 

**✨ New: Workspaces!**

In September 2025, Snowflake introduced Workspaces, which combines the functionality of Worksheets, Notebooks, File Manager, Query History, Results / Output, and the Database Explorer into a new, integrated development environment.

Workspaces will be the new default editor and replace Worksheets.

The updated instructions that follow will show you how to use Workspaces to complete all of the work in this badge course.

### 

**🥋 Create an SQL File & Run Some Code**

**NOTE**: Snowflake now offers SQL and Python files. **Please choose SQL files throughout this course.**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_024.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_025.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_026.png)

### 

**📓 Worksheet Context Menus**

Every .sql file has 4 dropdown menus near the top. Two are in the upper right corner and two are close to the first line of code. Which two are near the code? Which two are in the upper right corner?

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_028.png)

Troubleshooting a DOES NOT EXIST error? These four drop menus are a great place to start!!

Requires a correct answer to continue

There are three drop-menu settings or defaults for each worksheet.

What are the three drop-menu worksheet context settings?

Select 3 answers:

- Database
    
- Schema
    
- Account
    
- Warehouse
    
- Role
    
- Password
    
- Username
    

SUBMIT

# 

📓 Knowing What Will Run

### 

**📓 Knowing What Will Run & What Has Recently Run**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_030.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_031.jpg)

Requires a correct answer to continue

Look at the picture below.

If we click the RUN button now, what line(s) of code will run?

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_033.png)

1-5

3-5

3 only

4 only

5 only

SUBMIT

  

Requires a correct answer to continue

Look at the picture below. Look at the results section.

How can we know which line of code produced the result set shown?

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_034.jpg)

We know it was line 4 because the blue side bar always indicates the last statement run.

We can't know because line 3, 4, and 5 will create the same results.

We know it was line 3 because the cursor has moved to line 4 after running line 3.

SUBMIT

  

Requires a correct answer to continue

Look at the picture below.

The yellow background on the word select indicates an error.

What would you do to fix this code so it will not throw an error?

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_035.jpg)

Replace "select" with "SELECT" (upper case)

Put a blank line between each statement so it knows where one statement ends and another begins.

Place the cursor before the word "select" on line 4, before I hit RUN again so it knows to begin at the beginning of line 4.

Place a semi-colon at the end of line 4.

SUBMIT

# 

🥋 Running SHOW Commands

### 

**📓 The Object Pickers**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_037.png)

Object Pickers help you locate and pick objects. "Objects" is a generic terms for databases, schemas, tables, views and much more!

### 

**🥋 Run the SHOW DATABASES Command**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_039.png)

Running a SHOW DATABASES command is just like being at the first level of an Object Picker (but with more details, and the ability to copy and paste the info into a spreadsheet).

### 

**🥋 Run the SHOW SCHEMAS Command**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_040.png)

Running a SHOW SCHEMAS command is somewhat like being at the second level of an Object Picker. The difference is that the menu just above the code dictates which database you will get the SCHEMAS from.

### 

**🥋 Change the Database Context and Run the SHOW SCHEMAS Command Again**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_042.png)

There is another **SHOW SCHEMAS** command. This one is **SHOW SCHEMAS IN ACCOUNT**.

What happens if you add "IN ACCOUNT" to your command? How does the context menu affect the results?

Requires a correct answer to continue

How does adding "IN ACCOUNT" to the SHOW SCHEMAS command change the result set?

No schemas are shown. The command is not valid.

All schemas from all databases are shown (based on current role).

Only schemas from databases owned by ACCOUNTADMIN are shown.

SUBMIT

# 

🎯 Lesson 3 Challenge Lab

### 

**🎯 Check Your Work So Far**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_043.png)

Make sure SYSADMIN can see all the databases and schemas that have been created. If that role cannot see everything that ACCOUNTADMIN can see, FIX IT. As ACCOUNTADMIN you can Transfer Ownership or drop the object. Then, you can recreate the objects while your role is set to SYSADMIN.

Also, make sure there is no PUBLIC schema in the GARDEN_PLANTS database. You were supposed to delete that, remember?

You will encounter issues later if this is not fixed now.

Requires a correct answer to continue

What is the difference between a regular lab and a Challenge Lab?

Select 2 answers:

- Challenge labs are optional.
    
- Challenge labs are for advanced users only.
    
- Challenge labs ask you to complete tasks without giving you step-by-step instructions.
    
- Challenge labs don't teach new skills, they give you a chance to apply recently learned skills again.
    

SUBMIT

  

Requires a correct answer to continue

Refer to the  image below to answer this question.

You created the schema called VEGGIES but when you run the SHOW SCHEMAS command it does not appear.

Assuming your current worksheet role has access to the schema, what options below would make the schema appear in the results?

Select all that apply:

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_044.png)

- Change your default role to SYSADMIN (and run again).
    
- Set the worksheet database drop menu to GARDEN_PLANTS (and run again).
    
- Set the worksheet warehouse drop menu to VEGGIES_WH (and run again).
    
- Add "all" to the show schemas command (and run again).
    
- Add "in account" to the show schemas command (and run again).
    
- Add "where schema = 'VEGGIES' " to the show schemas command (and run again).
    

SUBMIT

# 

🎭 Uncle Yer Goes from Spreadsheets to SQL

Requires a correct answer to continue

What is the name of the coding language used for many databases?

Mark the name as well as the acceptable "nicknames" or pronunciations of the coding language.

Select 3 answers:

- Sequential
    
- "Segundo"
    
- "SeQueL"
    
- Structured Query Language
    
- Sequential Question Language
    
- Structured Query Lingo
    
- S.Q.L.
    

SUBMIT

  

Requires a correct answer to continue

The data in the spreadsheets isn't quite right for database use.

What are the two skills Tsai uses to re-structure the data to make it more ready for a database?

Select 2 answers:

- Structured Query Language
    
- Visual Basic
    
- Normalization
    
- Data Modeling
    

SUBMIT

  

Requires a correct answer to continue

Tsai classifies each column according to data type.

What are the two data types she uses in planning the ROOT_DEPTH table?

Select 2 answers:

- DECIMAL
    
- FLOAT
    
- NUMBER
    
- STRING
    
- BINARY
    
- TEXT
    
- VARCHAR
    

SUBMIT

# 

🥋 Create the ROOT_DEPTH Table

### 

**📓 Based on the Data, What Should Our Table Look Like?**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_047.jpg)

To read more about data types like TEXT, see Snowflake's online documentation [**here**(opens in a new tab)](https://docs.snowflake.com/en/sql-reference/data-types-text.html#data-types-for-text-strings).

To read more about data types like NUMBER, see Snowflake's online documentation [**here**(opens in a new tab)](https://docs.snowflake.com/en/sql-reference/data-types-numeric.html#number).

### 

**🥋 Create Your ROOT_DEPTH Table**

You can use the steps shown below, or scroll further down and get the code to copy/paste.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_048.png)

--Be sure to set your context menus
create or replace table ROOT_DEPTH (
   ROOT_DEPTH_ID number(1), 
   ROOT_DEPTH_CODE text(1), 
   ROOT_DEPTH_NAME text(7), 
   UNIT_OF_MEASURE text(2),
   RANGE_MIN number(2),
   RANGE_MAX number(2)
   ); 

### 

**🥋 Find the Table You Just Created in the Workspace Database Explorer**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_049.png)

### 

**📓 What If You Can't Find It?**

- Refresh the picker.
    
- Try the search box.
    
- Run a SHOW command.   
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_050.jpg)

### 

**📓 What If You Did Something Wrong?**

- Did you name it wrong? Rename it!
    
- Does the wrong role own it? Transfer the ownership!
    
- Is it in the wrong database or schema? Move it!!
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_051.jpg)

### 

**🥋 View the Definition of Your Table**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_052.png)

Notice that the SQL Code shown is different than the SQL code we ran. Snowflake made some changes behind the scenes.

Requires a correct answer to continue

Snowflake made some changes to the SQL as it created the table.

What changes were made?

Select 2 answers:

- Snowflake changed the name of the table.
    
- Snowflake converted the NUMBER data type to VARCHAR.
    
- Snowflake converted the TEXT data type to VARCHAR.
    
- Snowflake added a comma and digit to represent the number of decimals in each NUMBER column.
    
- Snowflake changed the owner from TYANG to SYSADMIN.
    

SUBMIT

# 

🥋 Insert a Row of Data into Your New Table

### 

**📓  Getting Rows of Data Into Table**

Now that you have a table, you'll want to put some data into it. There are many ways to get data into tables, but we'll start with the simplest and move through several options. As we move away from the simplest options, we will learn more efficient and effective ways of loading data.

Before the end of this workshop you will have experience loading data:

1. Using an INSERT statement from the Worksheet.
    
2. Using the Load Data Wizard.
    
3. Using COPY INTO statements.
    

### 

**🥋  Use the Data Preview Option**

Before you load a row of data into your table, first take note that your table has zero rows. Go to your .sql file, find the table in the Object Picker / Database Explorer, click the table name to choose the table, open the ellipses menu, and click on 'Preview Table'.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_053.png)

### 

**🥋 Insert One Row into Your ROOT_DEPTH Table Using the Insert Statement Below**

insert into root_depth 
values
(
    1,
    'S',
    'Shallow',
    'cm',
    30,
    45
);

### 

**🥋 Preview Your ROOT_DEPTH Table Again**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_055.png)

Preview your table again. Do you see a row in the table now?

Requires a correct answer to continue

How can you PREVIEW data in a table while in an AppUI Worksheet?

You can find the table in the Object Picker, click on the table name, then click on the magnifying glass symbol.

You can set your worksheet context TABLE drop menu to PREVIEW, which is designed for data previewing.

You can set your worksheet context ROLE drop menu to PUBLIC, which is designed for data previewing.

You can right-click on the table name and choose the "Table Preview Now" option.

SUBMIT

  

### 

**❗ The Dreaded** **Does Not Exist** **or** **Not Authorized** **Error**

You will see this message at some point. Everyone sees it. Maybe you will gloss over this text now, and end up coming back bc you search the "does not exist" error later in this workshop.

It's not that hard to fix. You either change your role, change the context menus in the worksheet, or fully qualify the object name by adding its full location.

Sometimes you need to change the ownership on something so it shows up. Sometimes you have to rename or move it. Ask yourself "Where am I looking for this thing? Is that where it is? Is that what it's named?" and "Who is looking for it? Does that role have access to it?"

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_054.png)

# 

📓 Select Stars and Limits

### 

**📓 Learning About Select Stars & Limits**

A Select Star statement starts with **SELECT *** (which is technically an asterisk). "Select Asterisk" takes longer to say so we just say "Select Star" instead.

A Select Star is a way to ask for all columns in the table, without having to list them one by one.

If you want all columns but not all rows, you can run a Select Star with a **LIMIT**. Limits make sure that you get just a small set of rows. That way, if there are millions of rows, you won't waste compute power, getting all of them, if all you want to see are a few of them.

SELECT *
FROM ROOT_DEPTH 
LIMIT 1;

Of course, our table only has one row right now, but later it will have more rows, and later we'll have other tables we create that we load with many more.  

Requires a correct answer to continue

What is the role of the * symbol in a SELECT statement?

You can use it to quickly ask for all rows.

You can use it to quickly ask for all tables.

You can use it to quickly ask for all columns.

You can use it to quickly ask for all schemas.

SUBMIT

  

Requires a correct answer to continue

What is the role of a LIMIT in a SELECT statement?

You can use it to quickly ask for a limited set of rows.

You can use it to quickly ask for a limited set of tables.

You can use it to quickly ask for a limited set of columns.

You can use it to quickly ask for a limited set of schemas.

SUBMIT

# 

🎯 Lesson 4 Challenge Lab

### 

**🎯 Add Two More Rows to the ROOT_DEPTH Table**

Edit the Insert Statement (twice) and run it (twice) to add two additional rows in your ROOT_DEPTH table.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_056.png)

- Run your SELECT * to view all three rows of your ROOT_DEPTH table.
    
- Compare your results with the screenshot shown here.
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_057.png)

**Note:** Challenge Labs are NOT OPTIONAL, they are **REQUIRED**.

Requires a correct answer to continue

Which Role should own your ROOT_DEPTH table?

ACCOUNTADMIN

SYSADMIN

PUBLIC

SUBMIT

  

### 

**📓 New to SQL? Need Some Help? Check Out the Code Samples Below**

/*
THESE ARE JUST EXAMPLES!
YOU SHOULD NOT RUN THIS CODE 
WITHOUT EDITING IT FOR YOUR NEEDS.
*/

--To add more than one row at a time
insert into root_depth (root_depth_id, root_depth_code
     , root_depth_name, unit_of_measure
     , range_min, range_max)  
values
     (5,'X','short','in',66,77)
     ,(8,'Y','tall','cm',98,99)
;

-- To remove a row you do not want in the table
delete from root_depth
where root_depth_id = 9;

--To change a value in a column for one particular row
update root_depth
set root_depth_id = 7
where root_depth_id = 9;

--To remove all the rows and start over
truncate table root_depth;

### 

**🏁 Ready for Lesson 5?**

- Do you have 5 Databases?
    
- Are all 5 of them visible by ACCOUNTADMIN?
    
- Are all 5 of them visible by SYSADMIN?
    
- Does the GARDEN_PLANTS database have 4 Schemas?
    
- Does the VEGGIES Schema have a single table called ROOT_DEPTH with 3 rows in it?
    

If you answer YES to all of these, you should proceed to Lesson 5!

If not, you should go back and fix anything that isn't right!

# 

🎭 Tsai Tells the Team About Worksheets & Warehouses

### 

**📓 Two Sets of Drop Menus, and a Key Difference Between Them**

Of the four drop lists, two are REQUIRED and two are more or less OPTIONAL.

**ROLE and WAREHOUSE Drop Menu Values are REQUIRED.**

You cannot run a select statement without a warehouse to provide the compute power and you cannot run a select statement without a ROLE to define whether that data is accessible to the person* trying to run it. There are some minor exceptions, but for now, accept this as a rule.  

_* in this case the "person" is a USER with a current ROLE._

**DATABASE and SCHEMA Drop Menu Values are SUGGESTED STARTING POINTS.**

The database and schema settings in a worksheet are just "home bases", or suggested starting places that tell Snowflake where to look for tables, views and other objects. These droplists exist so that you can simplify code and leave database and schema names out of your statements if you want to. Just because a Database is set in the menu, doesn't mean you can't run selects on other databases in the worksheet.

Requires a correct answer to continue

What settings can you choose for each Worksheet (often called the Worksheet Context) that make writing and running code easier to type and simpler to read?

Select 2 answers:

- The "home" Database
    
- The "home" Schema
    
- The "home" Table
    
- The "home" Account
    

SUBMIT

  

Requires a correct answer to continue

What settings MUST you choose for each Worksheet (also called the Worksheet Context) that, without them, code cannot run?

Select 2 answers:

- The warehouse to be used for all processing.
    
- The table to be used for compute.
    
- The account to be used for all processing.
    
- The user role to carry out the commands.
    
- The user name to carry out the commands.
    
- The account to carry out the commands.
    

SUBMIT

  

Requires a correct answer to continue

Two of the context settings in a worksheet are in the upper-right corner, while two are in the middle, closer to the code.

Why do you think they are positioned this way?

Select 2 answers:

- The set near the code is intended for convenience and simplicity of code.
    
- The set near the upper corner is intended for convenience and simplicity of code.
    
- The set near the upper corner is NOT for convenience, it is required.
    
- The set near the code is NOT for convenience, it is required.
    

SUBMIT

  

Requires a correct answer to continue

You created a table and added some rows, later you try to query the table and Snowflake says the table doesn't exist.

What is the first rule of Snowflake troubleshooting?

Check your USER name.

Check your default ROLE.

Check your current ROLE.

Check your ACCOUNT.

SUBMIT

# 

🎭 What is a Warehouse in Snowflake?

**Defining "Warehouse" in Snowflake:**

- People who have been working with data for awhile might think of the term "Data Warehouse" as referring to a special collection of data structures, but in Snowflake, warehouses don't store data.
    
- In Snowflake, Warehouses are "workforces" -- they are used to perform the processing of data.
    
- When you create a Warehouse in Snowflake, you are defining a "workforce."
    

**Teams are Clusters, Team Members are Servers:**

- In the video, the workforce of each warehouse is a team. A small warehouse has a small team, but just one team. An extra-large warehouse has a large team, but just one team.  
    
- Snowflake Warehouse Sizes like eXtra-Small, Small, Medium, etc. all have one cluster. A small warehouse has one cluster made up of just a few servers. A larger warehouse has one cluster, made up of more servers.
    

**Scaling Up and Down:**

- Changing the size of warehouse changes the number of servers in the cluster.
    
- Changing the size of an existing warehouse is called scaling up or scaling down.
    

**Scaling In and Out:**

- If multi-cluster/elastic warehousing is available (Enterprise edition or above) a warehouse is capable of scaling out in times of increased demand.  (Adding temporary teams, made up of a collection of temporary workers).
    
- If multi-cluster scaling out takes place, clusters are added for the period of demand and then clusters are removed (snap back) when demand decreases. (Removing temporary teams).
    
- The number of servers in the original cluster dictates the number of servers in each cluster during periods where the warehouse scales out by adding clusters.
    

Requires a correct answer to continue

Find all the true statements about Snowflake Warehouses below and select them.

Select 3 answers:

- Snowflake Warehouses are like Data Marts in that they hold subsections of an organization's data.
    
- Snowflake Warehouses were designed to hold data in structures based on Kimball and Inmon Data Warehousing theories.
    
- Snowflake Warehouses do not hold data.
    
- Snowflake Warehouses provide computing power to run queries, load data, and carry out other tasks.
    
- Functionally, a Snowflake Warehouse is more like a spreadsheet workbook than a laptop CPU.
    
- Functionally, a Snowflake Warehouse is more like a laptop CPU than a spreadsheet workbook.
    

SUBMIT

  

Requires a correct answer to continue

Scaling OUT/IN and scaling UP/DOWN are easily confused.

Check all the true statements about scaling, below.

Select 3 answers:

- Editing a XS Warehouse and making it a M is an example of scaling UP.
    
- Editing a XS Warehouse and making it a M is an example of scaling DOWN.
    
- Editing a XS Warehouse and making it a M is an example of scaling OUT.
    
- Editing a XL Warehouse and making it a M is an example of scaling UP.
    
- Editing a XL Warehouse and making it a M is an example of scaling DOWN.
    
- Editing a XL Warehouse and making it a M is an example of scaling OUT.
    
- When an XS Warehouse automatically adds clusters to handle an increase workload, this is an example of scaling UP.
    
- When an XS Warehouse automatically adds clusters to handle an increase workload, this is an example of scaling DOWN.
    
- When an XS Warehouse automatically adds clusters to handle an increase workload, this is an example of scaling OUT.
    

SUBMIT

  

Requires a correct answer to continue

Warehouses can be manually scaled UP or DOWN.

They can be set up so that they automatically scale OUT.

What did the video call the opposite of SCALING OUT?

De-Scaling

Snapping Back

Shedding Clusters

Scaling DOWN

SUBMIT

  

Requires a correct answer to continue

Warehouse scaling involves both servers and clusters.

Which statements are true about the role of servers and clusters in Warehouse sizing and scaling?

Select 7 answers:

- Cluster just means a "group" of servers.
    
- Server just means a "group" of clusters.
    
- An XS-sized warehouse (not scaled out) has 1 cluster.
    
- An M-sized warehouse (not scaled out) has 1 cluster.
    
- An M-sized warehouse (not scaled out) has more clusters than an XS-sized Warehouse.
    
- The number of servers in a warehouse is different, based on size (XS, S, M, etc)
    
- An XS-sized Warehouse, when scaled out, has more than 1 cluster.
    
- An M-sized Warehouse, when scaled out, has more than 1 cluster.
    
- A server can hold multiple clusters.
    
- A cluster can hold multiple servers.
    

SUBMIT

# 

📓 Just Because You Can...

### 

**📓 ...Doesn't Mean You SHOULD!!!**

In Snowflake, you can bring ENORMOUS compute power into play in just a few seconds! We want you to know this is possible, especially if you have a big gnarly job that needs monster computing power.

But, we also want you to know that most queries do not require MONSTER computing power.

In fact, Snowflake recommends always starting with eXtra-Small warehouses and only scaling up if you find a compelling reason do that. XS warehouses cost less than five dollars to run for an hour. Our biggest warehouse, the 6XL, costs over 500 times that amount, because it's like running 512 XS warehouses at one time.

Your free trial has 400 credits. This means you can run an XS for 400 hours or you can run a 6XL for less than one hour.  We don't extend the trials so if you use up your credits on big warehouses, you just have to start over.

For this workshop and others in the Hands-On series, it's better to keep your warehouse set to XS except in cases where we ask you to use size S instead.

For on-the-job Snowflake usage, you will likely have people who oversee the configuration of your warehouses. Warehouse over-sizing is the simplest way to make mistakes that cause big surprises on the monthly invoice so it's best to get accustomed to using XS and S warehouses most of the time and scale up only after careful consideration.

Snowflake recommends that each account have people who oversee costs and will have advanced knowledge of how to best choose warehouse sizes and configure the elasticity settings. These cost administrators will also be able to calculate whether a change in warehouse size will result in enough time savings to justify the costs incurred or even balance them out.

Requires a correct answer to continue

When should you scale up an existing warehouse?

When you're bored and it seems like something fun to try.

When you've carefully considered the impact of scaling up: increased credits used per hour.

When the devil on one shoulder is shouting louder than the angel on the other shoulder.

SUBMIT

  

### 

**📓 Protecting Yourself from Surprises**

Snowflake has many ways for you to monitor and control costs so that if someone makes a mistake, you'll know about it as quickly as possible.

The easiest way to put a protection in place is to set up a Resource Monitor. Follow the directions below to put one in place to protect your Trial account.

### 

**🥋 Set Up A Resource Monitor**

**NOTE: The Resource Monitors have moved to a sub-menu of Admin called "Cost Management" (or something like that).**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_059.png)

### 

**📓 Getting Notified**

When you get close to the daily limit, you'll receive a notification, usually on screen as an error message. Don't freak out! You created the Resource Monitor and you have control over the quota, so if you think you want to work for a few more hours bump the limit up to 5 for the day. It's all within your power.

You can also set your profile so that you get email alerts about Resource Monitors. Click near your USER name (or circular USER icon) in the lower left corner of the screen and choose Settings, then Notifications.  There you will find the option to receive email notifications.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_063.png)

Requires a correct answer to continue

A few hours from now, a message pops up saying "Warehouse 'COMPUTE_WH' cannot be resumed because resource monitor '{X}' has exceeded its quota."

How could you handle this issue?

Select 2 answers:

- I could take a break and pick up the workshop tomorrow when I will get 3 new credits to work with.
    
- I could take my Snowflake Account to one of those shady auto shops that rolls back odometers on cars.
    
- I could just edit the quota on the Resource Monitor so that my quota is now 5 per day (in spite of the name).
    
- I could copy and paste the "error" in the message boards as if Resource Monitors are a totally mysterious concept over which I can't possibly have full control.
    

SUBMIT

# 

🏁 Summary & Next Steps

**Does not exist errors** appear often, and they aren't always because you're using the wrong ROLE.

Sometimes you see a does not exist error for other reasons, like:

- you **created** something **in the wrong place** - like putting the ROOT_DEPTH table in the FRUITS schema.
    
- you are **looking in the wrong place** -- like "SELECT * FROM ROOT_DEPTH;" but your database context is set to "SNOWFLAKE_SAMPLE_DATA.PUBLIC".
    
- you have a **typo** -- like "SELECT * FROM GARENPLNT.VEGGIES.ROOT_DEPTH;"
    

Of course, it's also possible **you actually DID NOT CREATE** the item!! So check for that possibility as well!

Also, by now you should know...

- the difference between a USER and a ROLE.
    
- the difference between a USER and an ACCOUNT.
    
- the difference between DEFAULT ROLE, your CURRENT ROLE on the home page, and your WORKSHEET CONTEXT ROLE.
    
- how to find and change any of the four context menus that appear on each worksheet.
    
- which two context menus are DEFINITIVE and which two are just suggested starting points for your convenience.
    

If you do not know these things, you will struggle with the question below. If you struggle, please go back and review the lesson.  The question is not broken and we will not be telling you how many answers you need to choose.

Requires a correct answer to continue

You see this DOES NOT EXIST message when trying to run the select statement shown (see image below)?

What is the issue?

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_065.jpg)

Your default role is wrong.

Your current worksheet account is wrong.

Your worksheet database setting is wrong.

Your worksheet schema setting is wrong.

You have a typo.

Your account is not activated.

SUBMIT

  

### 

**🏁 Ready for the next lesson?**

**Do you understand how the worksheet context menus can cause a "Does Not Exist" error?**

If you answer YES, you should proceed! If not, you should go back, review the content from this lesson, and fix anything that isn't right!

# 

🎭 Meet DORA!

### 

**🧰 Create an API Integration**

You don't have to understand what it means to "create an API Integration," you just need to run the code below (using the ACCOUNTADMIN ROLE!).

use role accountadmin;

create or replace api integration dora_api_integration
api_provider = aws_api_gateway
api_aws_role_arn = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole'
enabled = true
api_allowed_prefixes = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora');

### 

**🧰 Create the GRADER Function**

You don't have to understand what it means to "create the GRADER function," you just need to run the code below (using the ACCOUNTADMIN ROLE!).

use role accountadmin;  

create or replace external function util_db.public.grader(
      step varchar
    , passed boolean
    , actual integer
    , expected integer
    , description varchar)
returns variant
api_integration = dora_api_integration 
context_headers = (current_timestamp, current_account, current_statement, current_account_name) 
as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader'
; 

### 

**🤖 Is the GRADER Function working?**

When we show up to the present moment with all of our senses, we invite the world to fill us with joy. The pains of the past are behind us. The future has yet to unfold. But the now is full of beauty simply waiting for our attention.

use role accountadmin;
use database util_db; 
use schema public; 

select grader(step, (actual = expected), actual, expected, description) as graded_results from
(SELECT 
 'DORA_IS_WORKING' as step
 ,(select 123) as actual
 ,123 as expected
 ,'Dora is working!' as description
); 

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_066.jpg)

If you get a message saying the **GRADER function doesn't exist**, check to make sure your role is set to ACCOUNTADMIN in the upper right corner of the worksheet!

If you still get an error, type **_show functions in account;_** in a worksheet.

If your GRADER function is not in your UTIL_DB.PUBLIC schema, you have two options:

1. 1) Move the function by renaming it. Something like:
    
    1. ALTER FUNCTION GARDEN_PLANTS.VEGGIE.GRADER RENAME TO UTIL_DB.PUBLIC.GRADER
        
2. 2) Edit the USE DATABASE line before running any GRADER calls.
    

**NOTE:  You will have 90 days from the time of your first DORA check to the last DORA check if you want to receive the badge. After that, you would need to re-run tests older than 90 days old.**

### 

**🧰 Let's Gooooooooo!**

If the DORA check script worked, you are ready to move on to the REAL DORA code checks!

# 

🥋 Preparing for Code Checks

### 

**🥋 Using Code to Check Your Work**

You were asked to set up 3 schemas in a GARDEN_PLANTS database. You were also asked to delete a schema. Let's run some code to see if you did those tasks.

select * 
from garden_plants.information_schema.schemata;

Requires a correct answer to continue

How many schemas does your (should your) GARDEN PLANTS Database have?

2

3

4

SUBMIT

  

### 

**📓 What Did I Do Wrong?**

Did you run the query and get unexpected results? Here are some potential mistakes:

1. You have a typo in the schema name, like "WEGGIES" instead of "VEGGIES"
    
2. You put the schemas in the wrong database, like UTIL_DB, instead of GARDEN_PLANTS
    
3. You don't have your role set so that you can see the objects, like you created them using ACCOUNTADMIN, but your worksheet is set to SYSADMIN.
    

### 

**📓 How Can I Fix Things?**

Typo:

**_ALTER SCHEMA GARDEN_PLANTS.WEGGIES RENAME TO GARDEN_PLANTS.VEGGIES;_**

Wrong Place:   

**_ALTER SCHEMA DEMO_DB.VEGGIES RENAME TO GARDEN_PLANTS.VEGGIES;_**

Cant Find:   Change the Role Setting on your worksheet or transfer the ownership of your object.

### 

**🥋 Checking for Schemas by Name**

Now let's check to see if the schemas you created have the right names. If this code doesn't return 3 rows, you might have named your schemas different names.

SELECT * 
FROM GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 

### 

**🥋 Counting the Number of Correctly Named Schemas**

Now let's count the number of schemas you created in the right place, with the right names.

select count(*) as schemas_found, '3' as schemas_expected 
from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 

### 

**📓 Using the INFORMATION_SCHEMA to Query Metadata**

The word "metadata" means "data about data."

The INFORMATION_SCHEMA that gets created in every Snowflake Database holds metadata. In other words, it holds statistics about the number of databases, schemas, tables, views and more. It also holds data about the object names and other object details.

Notice that in all the queries above, we are using the INFORMATION_SCHEMA to double-check our work and make sure we completed the tasks correctly.

# 

🔍 What is Metadata?

Requires a correct answer to continue

What is the definition of Metadata?

Data about meta.

Data that is above other data.

Data about data.

SUBMIT

  

Requires a correct answer to continue

Where does Snowflake store some of its Metadata?

The INFORMATION_DB database of each account.

The METADATA_SCHEMA of each database.

The INFO_METADATA schema of each database.

The INFORMATION_SCHEMA schema of each database.

SUBMIT

  

Requires a correct answer to continue

If we want to check for the schemas we created, why not just look with our own eyes to see if they are there?

Select 3 answers:

- Because if we misspelled something, we might not notice the name issue, but checking via code might catch it.
    
- Because we may want to automate the check for some reason.
    
- Because coding things is fun.
    

SUBMIT

# 

🤖 DORA DWW01

### 

**🤖 Run Each Statement in Your Worksheet to Send a Report to DORA About Your Schemas**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--You can run this code, or you can use the drop lists in your worksheet to get the context settings right.
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;

--Do NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT
 'DWW01' as step
 ,( select count(*)  
   from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA 
   where schema_name in ('FLOWERS','VEGGIES','FRUITS')) as actual
  ,3 as expected
  ,'Created 3 Garden Plant schemas' as description
); 

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_068.jpg)

### 

**❔ Are Some Edits to the Code Okay?**

**No**. In the past, small edits were allowed. However, people were finding too many ways to manipulate the code checks in their favor, so we now run an audit using the HASH function to make sure that the code run matches the code we provide to you.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_067.png)

The screenshots above were created when a very conscientious student named Shweta removed a single line break from a single test and had to wait an extra week to receive her badge while she filed research requests and waited to hear back from us! When we say DO NOT EDIT, we mean **_DO NOT EDIT!!!_**

# 

🤖 DORA DWW02

### 

**🤖 Run Each Statement in Your Worksheet to Send a Report to DORA About Your Schemas**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Remember that every time you run a DORA check, the context needs to be set to the below settings. 
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;

--Do NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW02' as step 
 ,( select count(*) 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA 
   where schema_name = 'PUBLIC') as actual 
 , 0 as expected 
 ,'Deleted PUBLIC schema.' as description
); 

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_069.jpg)

# 

🤖 DORA DWW03

### 

**🤖 Run These Statements in Your Worksheet to Send a Report to DORA About Your Table**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

-- Do NOT EDIT ANYTHING BELOW THIS LINE 
-- Remember to set your WORKSHEET context (do not add context to the grader call)
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW03' as step 
 ,( select count(*) 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'ROOT_DEPTH') as actual 
 , 1 as expected 
 ,'ROOT_DEPTH Table Exists' as description
); 

### 

**🥋 Use Query History to Check Your Test Results**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_071.png)

# 

🤖 DORA DWW04

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW04' as step
 ,( select count(*) as SCHEMAS_FOUND 
   from UTIL_DB.INFORMATION_SCHEMA.SCHEMATA) as actual
 , 2 as expected
 , 'UTIL_DB Schemas' as description
);

# 

🤖 DORA DWW05

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
 SELECT 'DWW05' as step 
,( select row_count 
  from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
  where table_name = 'ROOT_DEPTH') as actual 
, 3 as expected 
,'ROOT_DEPTH row count' as description
);

# 

👂 DORA is Listening!

### 

**🧰 Tell Us About Your Snowflake Trial Account**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DORA.png)

We need information about your Trial Account so we can track your lab work!

You have the [learn.snowflake.com(opens in a new tab)](http://learn.snowflake.com/) account (where these words appear), and you have your Snowflake Trial Account where you are doing labs. How will DORA know which labs go with which learning account?

There's an app for that!!

Use the pages in the app to:

- ✏️ Edit Your Name and/or Email
    
- ⭐ Format Your Display Name - This is how your name will appear on your badge!
    
- 🔗 Create a LINK between your learning account and your Snowflake Trial Account
    
- 🤖 View the DORA Lab Checks you have run to see how you are progressing
    

Visit [**https://ysa.snowflakeuniversity.com**(opens in a new tab)](https://ysa.snowflakeuniversity.com/)

You will need your **UNI_ID** and **UUID** to log into the YSA App, which you can find on the course registration page at training.snowflake.com:

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/p6rYmV/ysa_login_screen.png)

We recommend that you store this info in a safe place, as you will need it any time you access the YSA App to check your course progress & badge status.

# 

🎭 Insert Statements Get Old, Fast

### 

**🎭 Uncle Yer Learns About the Load Wizard & File Formatting**

### 

**📓 Vegetable Details Table Data**

On the next page, you're going to be downloading a file created by Uncle Yer that contains 21 rows. Uncle Yer decided to shorten the words "Deep", "Shallow" and "Medium" to just the first letters. Then he saved the data out to a CSV file.

CSV stands for Comma Separated Values. This means that his file separates the values by inserting a comma in between each value in the row.  If you open a CSV file in Excel or Google Sheets, those programs will interpret the commas as separators (hiding them from you) and displaying the values in different columns.

Instead of opening with Excel or Sheets, be sure to open the file with a simple text editor like Notepad or BBEdit. Then you will see the commas that are separating the values in the rows. It is important to know how to look at a file using a simple text editor because sometimes characters other than commas are used to separate the values in a file.  

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_075.jpg)

Requires a correct answer to continue

Why should you open Uncle Yer's CSV file in a simple text editor instead of Excel or sheets?

Because some of the plant names have tabs in them

Because Excel is copyrighted

So you can see which words aren't capitalized

So you can see how commas are separating the values in each row.

SUBMIT

  

### 

**🥋 Create a Vegetable Details Table**

create table garden_plants.veggies.vegetable_details
(
plant_name varchar(25)
, root_depth_code varchar(1)    
);

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_076.png)

# 

🥋 Loading Table Rows from a File (A to K)

### 

**🥋 Download this File**

[

veggie_details_a_to_k_comma_opt_enclosed.csv

288 B

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/veggie_details_a_to_k_comm.csv)

### 

**🥋 Upload the File Into Your Veggie Details Table!**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_078.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_079.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_080.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_081.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_082.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_083.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_084.jpg)

# 

🥋 Loading Table Rows from a File (K to Z)

### 

**🥋 Download a SECOND FILE**

[

veggie_details_k_to_z_pipe.csv

283 B

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/veggie_details_k_to_z_pipe.csv)

### 

**🎯  Challenge Lab:  Load A SECOND FILE into the Table**

Load the file into the same table, using the same method you just used. Note that there is at least one setting you will need to change when loading.

**The columns are NOT separated by commas this time.**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_086.jpg)

TIP: Don't use Excel to open CSV files if you want to see what characters are used to separate columns and rows. Use a simple text editor. On Windows, Notepad works well. On Mac, TextEdit works well.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_087.jpg)

Load the second file (K through Z).

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_088.png)

Then, check your table by running a select statement in a worksheet. You should see 42 rows. If you reverse the sort order, you should be able to see Zucchini at the top, proving to yourself you loaded the second file.  

If you accidentally load the same file twice and want to start over, run a TRUNCATE command to empty out the table.

**TRUNCATE TABLE GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS;**

Then, start the loading process over again.

# 

🤖 DORA DWW06

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW06' as step
 ,( select count(*) 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 1 as expected
 ,'VEGETABLE_DETAILS Table' as description
);

# 

🎯 Viewing Our Table Data

### 

**🎯 View Your Vegetable Details Table**

This challenge lab does not include step-by-step details, but guidance for achieving several goals.

- View your data
    
- Notice a plant name that appears twice in the data set
    
- Find a way to get rid of it
    
- View your data again
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_090.png)

We are surprised to see two Spinach rows!

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_091.png)

One of them has an "S" for shallow roots and the other has "D" for deep roots. We need to get rid of the row that says spinach roots are deep. First lets isolate the "D" row.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_092.png)

Now let's remove only the Spinach row with "D" in the ROOT_DEPTH_CODE column.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_093.png)

Now, let's look at all the data again and make sure there are no vegetable names that appear twice.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_094.png)

Looks great!

Requires a correct answer to continue

Let's review our recent actions.

Which of the following tasks have we performed?

Select 6 answers:

- Loaded 42 rows into the VEGETABLE_DETAILS table.
    
- Viewed a chart showing a count of each value in the PLANT_NAME column.
    
- Found two rows where the PLANT_NAME was "Celery."
    
- Found two rows where the PLANT_NAME was "Spinach."
    
- Found two rows where the PLANT_NAME was "Arugula."
    
- Removed one row that had a ROOT_DEPTH_CODE of "D".
    
- Checked to confirm we had 41 rows.
    
- Confirmed a count of 1 for each value in the PLANT_NAME column using a chart.
    

SUBMIT

# 

🤖 DORA DWW07

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW07' as step
 ,( select row_count 
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 41 as expected
 , 'VEG_DETAILS row count' as description
); 

### 

**🏁 Ready to move forward?**

- Does your ROOT_DEPTH table have 3 rows?
    
- Does your VEGETABLE_DETAILS table have 41 rows?
    
- Are both tables in the VEGGIES schema of the GARDEN_PLANTS database?
    

If you answer YES to all of these, you should continue! If not, you should go back and fix anything that isn't right!

# 

📓 Other Ways for Interacting with Data!

### 

**📓 Other Ways to Create Data Rows or Interact with Data**

In this lesson you'll learn to create and use Snowflake Notebooks and Streamlit-in-Snowflake  data entry forms.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_097.jpg)

Let's start by creating a new table to enter data into.

### 

**🥋 Copy the CREATE TABLE Code from the VEGETABLE_DETAILS Table**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_099.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_100.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_101.jpg)

# 

🥋 Create a Snowflake Notebook

### 

**🥋 Create a Snowflake Notebook & Add a Markdown Cell**

**Note: You can no longer include an apostrophe in a Notebook name so use the title "Uncle Yers Root Depth Notebook" as the name, instead.**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_103.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_104.jpg)

### 

**📓 What is Markdown?**

Markdown is a method to format text using plain text symbols. You can read about markdown in many places or [you can read about it in the Snowflake Docs(opens in a new tab)](https://docs.snowflake.com/en/user-guide/ui-snowsight/notebooks-develop-run#markdown-basics).

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_106.jpg)

Feel free to explore Markdown on your own.

### 

**🥋 Delete the Example Cells**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_108.jpg)

Repeat the process until ONLY the MARKDOWN CELL remains.

# 

🥋 Add Cells to the Notebook

### 

**🥋 Add a SQL Cell & Name It**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_109.jpg)

### 

**🥋 Place an Insert Statement into Your Notebook Cell**

insert into garden_plants.flowers.flower_details
select 'Petunia','M';

### 

**🥋 Paste the Insert Statement & Run the Cell**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_111.jpg)

### 

**🎯 Create a New Cell & Fill It with a Select ***

- Create another SQL Cell
    
- Name it "check_the_table"
    
- Write a SELECT * statement on the flower_details table
    
- Run the cell

# 

🥋 Use Variables in the Notebook

### 

**🎯 Create Two More Cells & Reorder the Cells**

- Create 3 More SQL Cells
    
- Name one "set_flower_name" (empty for now)
    
- Name another "set_root_depth_code" (empty for now)
    
- Name the 3rd cell "check_my_variables" (empty for now)
    
- Rearrange the cells using the methods shown here:
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_113.jpg)

Your cells should be in the order shown here:

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_114.png)

### 

**🥋 Fill In the New SQL Cells and Run Them**

set rdc = 'S';
set fn = 'Lilac';
select $fn, $rdc;

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_116.jpg)

### 

**🥋 Replace the Flower Name & Root Depth Code with the Variables**

When we show up to the present moment with all of our senses, we invite the world to fill us with joy. The pains of the past are behind us. The future has yet to unfold. But the now is full of beauty simply waiting for our attention.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_117.png)

### 

**🥋 Run the Last Cell to Check Your Insert**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_118.jpg)

# 

🥋 Put Finishing Touches on Your Notebook

### 

**🥋 Edit Your Markdown Cell**

Notebooks can be used to share process flows with others. Perhaps Tsai will set up a few different notebooks for Uncle Yer so that he can  remember how to do different process tasks.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_120.png)

### 

**🎯 Use Your Notebook to Create 3 Additional Rows in the Flower Detail Table**

- A Sunflower should have deep roots.
    
- Lavender can have shallow roots.
    
- A Tulip has a bulb, not roots, but we'll say they need medium root depth.
    

### 

**🥋 Run the Last Cell to Check Your Inserted Rows**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_121.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_122.png)

# 

🤖 DORA DWW08

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
   SELECT 'DWW08' as step 
   ,( select iff(count(*)=0, 0, count(*)/count(*))
      from table(information_schema.query_history())
      where query_text like 'execute NOTEBOOK%Uncle Yer%') as actual 
   , 1 as expected 
   , 'Notebook success!' as description 
);

# 

🥋 Create a SiS Form

### 

**🎯 Create a Fruit Details Table - Model it After the Other 2 Details Tables**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_124.jpg)

### 

**🥋 Create a Streamlit-in-Snowflake Data Entry Form**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_126.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_127.jpg)

### 

**🥋 Delete Most of the Sample Code**

On the code side of the screen, delete all code from line 18 to the end. Then click 'Run" in the upper left corner.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_128.jpg)

# 

🥋 Enable the SiS Form for Data Entry

### 

**🥋 Edit the Form Title & Instruction Line**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_130.jpg)

After every edit, click the Run button in the upper-right corner.

### 

**🥋 Add Input Fields**

st.text_input('Fruit Name:')
st.selectbox('Root Depth:', ('S','M','D'))

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_131.jpg)

### 

**📓 Add Variables to Capture Input**

Remember that with our notebook we declared two variables. For the fruit name we named our variable "fn" and for our root depth code we named our variable "rdc."

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_132.jpg)

In this streamlit form, we are not writing SQL code, we're writing Python, so we don't need to use the SET keyword. Instead we can just put:

**fn =**

and

**rdc =**

Also, if we put it in front of the input code, whatever is entered into those fields will get stored in the variables.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_133.png)

# 

🥋 Capturing Form Entries

### 

**🎯 Set Variables fn and rdc**

Make changes to the code so that whatever is entered into the Fruit Name field is stored in a variable named fn.

Make changes to the code so that whatever is chosen from the Root Depth select box is stored in a variable named rdc.

### 

**🥋 Add a Submit Button**

if st.button('Submit'):
    st.write('Fruit Name entered is ' + fn)
    st.write('Root Depth Code chosen is ' + rdc)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_135.png)

### 

**📓 Python Conventions**

After an if statement, Python will do everything that is indented to the same level so, Python expects at least one indented line.

Without an indented line, there is no need for the IF statement to exist. If you see a red arrow or dashes underlining something, Python is confused about your indentation.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_136.png)

Generally speaking, Python is very picky about indentation. (SQL doesn't care!!)

In most Python editors you can't use a tab on one line and 4 spaces on another. You have to be consistent. But Streamlit-in-Snowflake (SiS) will take care of this for you.

# 

🥋 Prepare an Insert Statement

### 

**🥋 Prepare to Write the Data to the Database**

Add these lines as part of the if block.

sql_insert = 'insert into garden_plants.fruits.fruit_details select '+fn+','+rdc
st.write(sql_insert)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_137.png)

### 

**📓 Escape Characters**

To build our insert statements, we used some strings and some variables. In between the strings and variables we had the + symbol. The string parts were enclosed in single quotes. But now we need to add single quotes to the output. How can we tell Python which single quote characters are enclosing our strings and which ones we want as part of the strings?

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_138.png)

In coding, the way to distinguish between a symbol that is performing a job (like enclosing a string) and a symbol that needs to be part of the output is to put an ESCAPE CHARACTER in front of it.

An escape character means "the next character you see is meant to be taken literally. It is not performing a job here."

In Python the escape character is a back slash.

So the code below is confusing to Python:

       **_my_greeting_string = 'Hello ma'am'_**

But adding the backslash to the word ma'am makes sense:

       **_my_greeting_string = 'Hello ma\'am'_**

The quote in front of the "H" and the quote after the "m" are performing the job of enclosing the greeting. The quote in the middle of ma'am is part of the greeting.

### 

**🥋 Fix the Insert Statement**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_139.png)

# 

🥋 Writing Our Entries to the Database

### 

**🥋 Comment Out Some Write Lines**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_141.png)

We could delete the lines, but when we comment them out, we can easily add them back later, in case we need them for troubleshooting.

### 

**🥋 Run the SQL and See a Results Message**

1. Comment out the line **st.write(sql_insert)**
    
2. Add these two lines then Run the app (and click the Submit button):
    
    - **_result = session.sql(sql_insert)_**
        
    - **_st.write(result)_**
        

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_142.jpg)

### 

**🎯 Check Your Fruit Details Table & Add More Rows**

Navigate out of the SiS app/Entry Form and check the FRUIT_DETAILS table to see if you added a row.

Once you have confirmed that your app works, add two more rows (for a total of 3 rows).

You can use any fruit names you want with any root depth settings.

[  
](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/index.html#/lessons/qV3fwpD6TvnrCYawrtJO3nk2hGF401wd)

# 

🤖 DORA DWW09

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

Remember to set your context menus because those are the necessary settings to run the GRADER function. Do this anytime you run the GRADER function.

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW09' as step
 ,( select iff(count(*)=0, 0, count(*)/count(*)) 
    from snowflake.account_usage.query_history
    where query_text like 'execute streamlit "GARDEN_PLANTS"."FRUITS".%'
   ) as actual
 , 1 as expected
 ,'SiS App Works' as description
); 

### 

**🏁 Summary & Next Steps**

For more information on Snowflake Notebooks see the [About Snowflake Notebooks(opens in a new tab)](https://docs.snowflake.com/en/user-guide/ui-snowsight/notebooks) in the docs.

For more information on Streamlit in Snowflake see the [About Streamlit in Snowflake(opens in a new tab)](https://docs.snowflake.com/en/developer-guide/streamlit/about-streamlit) in the docs.

If you've completed all tasks and DORA tests up to this point, you're ready to move on to the next section!

# 

🥋 Create a Snowflake Stage Object

### 

**🥋 Create a Snowflake Stage Object**

Create a stage that points to an internal directory that can hold your files before you load them into tables.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_145.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_146.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_147.png)

# 

🤖 DORA DWW10

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW10' as step
  ,( 
    select count(*) 
    from UTIL_DB.INFORMATION_SCHEMA.stages
    where stage_name='MY_INTERNAL_STAGE'
    AND stage_type IS NULL
    ) as actual
  , 1 as expected
  , 'Internal stage created' as description
 );

# 

🥋 Load a File into Your Stage

### 

**🥋 Download a File & Upload It To Your Stage**

[

VEG_NAME_TO_SOIL_TYPE_PIPE.txt

536 B

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/VEG_NAME_TO_SOIL_TYPE_PIPE.txt)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_149.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_150.jpg)

### 

**📓 A Warehouse Metaphor for Loading Data**

Though you can't see it, your stage is based on an AWS Storage area called an S3 bucket. If your Snowflake account was in an Azure Region, your stage would be in an Azure Blob.  Likewise, a GCP-based Snowflake account would have staging areas in GCP buckets.

You will use a COPY INTO statement to move a file from the stage into a table.  

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_152.jpg)

To COPY INTO statement, it is best to have 4 things in place:

- **A table**
    
- **A stage object**
    
- **A file**
    
- **A file format**
    

The file format is sort of optional, but it's a cleaner process if you have one, and we do!

copy into my_table_name
from @my_internal_stage
files = ( 'IF_I_HAD_A_FILE_LIKE_THIS.txt')
file_format = ( format_name='EXAMPLE_FILEFORMAT' );

You already have your stage, and you have a file loaded into that stage. All you need now is a table and a file format. Once you have those, you'll be able to run a COPY INTO statement.

# 

🥋 Use the COPY INTO Statement to Load Data

### 

**🥋 Create a Table for Soil Types**

Make sure you create it in the GARDEN_PLANTS database, in the VEGGIES schema.

create or replace table vegetable_details_soil_type
( plant_name varchar(25)
 ,soil_type number(1,0)
);

### 

**🥋 Create a File Format**

create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;

### 

**🥋 A Copy Into Statement You Can Run**

copy into vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW );

# 

🤖 DORA DWW11

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DWW11' as step
  ,( select row_count 
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
    where table_name = 'VEGETABLE_DETAILS_SOIL_TYPE') as actual
  , 42 as expected
  , 'Veg Det Soil Type Count' as description
 );

# 

🥋 Query a File Before You Load It

### 

**🎯 Download and Upload This File Into Your Stage**

[

LU_SOIL_TYPE.tsv

545 B

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/LU_SOIL_TYPE.tsv)

### 

**🥋 Create Another File Format**

create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW 
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = ',' --commas as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
--this means that some values will be wrapped in double-quotes bc they have commas in them
    ;

### 

**🥋 Explore the Effect of File Formats On Data Interpretation**

You can query data before you load it. Look at the data in a file we are about to load and see how the data changes based on what we tell Snowflake about how the data is formatted.

--The data in the file, with no FILE FORMAT specified
select $1
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv;

--Same file but with one of the file formats we created earlier  
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

--Same file but with the other file format we created earlier
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );

### 

**💪🏽 Do You Have What It Takes?**

**🫀 Do You WANT this Badge BAD ENOUGH?**

Neither of the file formats used above seem like the right file format to load this TSV file. It's time for you to challenge yourself to figure out the magic combination of file format settings that WILL LOAD THE FILE CORRECTLY.

People who become developers have this need to "win" over computers. When we can't figure something out we might say **"Ugh! Forget it!"** for an hour or two but eventually our mindset comes back to, **"Heck no! This computer will not win! I am smarter than it is! I CAN figure this out and I WILL figure this out!!"**

We designed the next Challenge Lab to weed out the people who thought this course was going to be a **Click-Next-50-Times-To-Receive-Your-Badge! kind of course.** **That's not what, or who, this course is for!!**

We know this exercise is challenging! But we promise you already have the tools to complete this challenge. You may need to go back and do some reviewing on your own, but the information is THERE.

# 

🎯 Challenge Lab: Create a File Format, Use it in a COPY INTO

### 

**🎯 Create a File Format That Makes the Data Look Great**

1. Before you loaded the TSV file to your stage, you downloaded it to your local machine. Open the local file and LOOK at the file structure. Use a good text editor (NOT EXCEL, NOT GOOGLE SHEETS).
    
2. Do you see any issues in the data?  Do not edit the data. We want you to create a file format that can handle the file's data without any direct file edits.
    
3. Create a file format that will help you load files with these properties. Name the file format: **L9_CHALLENGE_FF**
    
4. Make sure the data looks like the screenshot below when you use your new File Format in the query.
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_154.jpg)

### 

**TIPS and TRICKS**

- All flat files are loaded using file formats that have a type of CSV (Comma Separated Values). So, use **TYPE = CSV** for any flat file (TSV, Pipe Delimited, .txt, etc.).
    
- The **FIELD_DELIMITER** property is very important. It should match the actual Column Separator being used in the file.
    
- Once you create your FILE FORMAT, if you want to edit it, just add OR REPLACE to the code (as in **CREATE OR REPLACE FILE FORMAT**) and you will be editing the file format by re-defining it.
    
- It is possible to load the data without creating the file format, but as you might have guessed, DORA will be looking for the **L9_CHALLENGE_FF** file format.
    
- If columns in a file were separated by a tab, you would put **FIELD_DELIMITER = '\t'** as a property in the file format you created.
    

### 

**🥋 Create a Soil Type Look Up Table**

Make sure you create it in the GARDEN_PLANTS database, in the VEGGIES schema. Also, make sure it is owned by the SYSADMIN role.

You can use the CONTEXT settings to make sure these things happen or you can use a combination of CONTEXT settings and fully qualifying the table name before you run the code to create the table.

create or replace table LU_SOIL_TYPE(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar(15),
SOIL_DESCRIPTION varchar(75)
);

### 

**🎯 Create a COPY INTO Statement to Load the File into the Table**

1. Create a **COPY INTO** command to load the file (**LU_SOIL_TYPE.tsv**) from your stage to the **LU_SOIL_TYPE** table.
    
2. Load the table by running the COPY INTO command you wrote.  DO NOT use 'SKIP_FILE' or 'CONTINUE' for the ON_ERROR option, even if the system suggests it.
    
3. Run a **SELECT *** on the table to see if loaded nicely.
    
4. If it didn't, truncate the table, fix the file format (or COPY INTO) and load it again.

# 

🎯 Challenge Lab: Create a Table, Use It in a COPY INTO!

### 

**🎯 Choose a File Format, write the COPY INTO, Load the File into the Table**

Start by downloading this file:

[

veg_plant_height.csv

781 B

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/veg_plant_height.csv)

1. Look at the data. Do not edit the data. Just look to understand it.  
    
2. Create a table called **VEGETABLE_DETAILS_PLANT_HEIGHT** in the **VEGGIES** schema. Use the header row of the file to get your column names. Choose good data types for each column.
    
3. Upload the file into your stage. (Zoom out in your browser if you cannot see the submit button)
    
4. Choose an existing file format (one you already created) that you think can be used to load the data.
    
5. Use a **COPY INTO** command to load the file from the Stage to the table you created. 
    

**NOTE: The most common error is "Number of columns in file (1) does not match that of the corresponding table (4)" if you see this message, you have not chosen the correct file format. Or, sometimes, you are trying to load the wrong file. Double-check the file, file format, and table to make sure they match up.**

# 

🤖 DORA DWW12

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
      SELECT 'DWW12' as step 
      ,( select row_count 
        from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
        where table_name = 'VEGETABLE_DETAILS_PLANT_HEIGHT') as actual 
      , 41 as expected 
      , 'Veg Detail Plant Height Count' as description   
);

# 

🤖 DORA DWW13

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW13' as step 
     ,( select row_count 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
       where table_name = 'LU_SOIL_TYPE') as actual 
     , 8 as expected 
     ,'Soil Type Look Up Table' as description   
);

# 

🤖 DORA DWW14

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE 
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
     SELECT 'DWW14' as step 
     ,( select count(*) 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS 
       where FILE_FORMAT_NAME='L9_CHALLENGE_FF' 
       and FIELD_DELIMITER = '\t') as actual 
     , 1 as expected 
     ,'Challenge File Format Created' as description  
);

# 

👂 Check In With DORA

### 

**🧰 Use the App To Check Your Work**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/NLclzE/DORA.png)

The Snow-Amazing App can tell you:

- What tests DORA has received from you via the GRADER function.
    
- Whether you passed each test.
    
- Whether each test was valid. If any tests were changed by you they are marked INVALID.
    

While you're in the app:

- Double-check your email. Did you spell it correctly?
    
- Double-check your display name. Is that how you want it to appear on your badge? You can use accents and any unicode characters so make your name look exactly how you want it to appear!
    
- Make sure you have a link record that includes your ACCOUNT ID AND ACCOUNT LOCATOR. Without both pieces of information in the link record, your badge will be blocked.
    

Visit [**https://ysa.snowflakeuniversity.com**(opens in a new tab)](https://ysa.snowflakeuniversity.com/)

You will need your **UNI_ID** and **UUID** to log into the YSA App, which you can find on the course registration page at training.snowflake.com:

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/p6rYmV/ysa_login_screen.png)

We recommend that you store this info in a safe place, as you will need it any time you access the YSA App to check your course progress & badge status.

# 

🎭 Data Storage: A Short History

### 

**🎭 Data Storage: A Short History**

# 

🥋 Create the Library Card Catalog DB

### 

**🥋 Create a New Database and Table**

use role sysadmin;

// Create a new database and set the context to use the new database
create database library_card_catalog comment = 'DWW Lesson 10 ';

//Set the worksheet context to use the new database
use database library_card_catalog;

# 

🎭 Data Storage: Entities and Relationships

# 

🎭 Data Storage: From ERDs to Tables

# 

🥋 Create and Fill the Books Table

### 

**🥋 Create the Book Table**

use database library_card_catalog;
use role sysadmin;

// Create the book table and use AUTOINCREMENT to generate a UID for each new row

create or replace table book
( book_uid number autoincrement
 , title varchar(50)
 , year_published number(4,0)
);

// Insert records into the book table
// You don't have to list anything for the
// BOOK_UID field because the AUTOINCREMENT property 
// will take care of it for you

insert into book(title, year_published)
values
 ('Food',2001)
,('Food',2006)
,('Food',2008)
,('Food',2016)
,('Food',2015);

// Check your table. Does each row have a unique id? 
select * from book;

# 

🥋 Create the Author Table

### 

**🥋 Create the AUTHOR Table**

// Create Author table
create or replace table author (
   author_uid number 
  ,first_name varchar(50)
  ,middle_name varchar(50)
  ,last_name varchar(50)
);

// Insert the first two authors into the Author table
insert into author(author_uid, first_name, middle_name, last_name)  
values
(1, 'Fiona', '','Macdonald')
,(2, 'Gian','Paulo','Faleschini');

// Look at your table with its new rows
select * 
from author;

### 

**📓 Another Option for Generating Unique Identifiers - A Sequence**

When we created the Book table, we used the "autoincrement" property to create a unique id for each book in the table. This is a simple, straightforward way of generating unique ids for table rows. However, you may sometimes want more control over a sequence of unique ids.

In that case, you can create something called a SEQUENCE object. In the next set of labs, we'll create a SEQUENCE we can use with our AUTHOR table.

# 

🥋 Create a Sequence

### 

**🥋 Create a Sequence**

A sequence is a counter. It can help you create unique ids for table rows. There are ways to create unique ids within a single table called an AUTO-INCREMENT column. Those are easy to set up and work well in a single table. A sequence can give you the power to split information across different tables and put the same ID in all tables as a way to make it easy to link them back together later.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_156.png)

**NOTE:  If you do not include the word ORDER, your values will skip by 100 each time.**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_156a.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_156b.png)

### 

**🥋 View the Sequence Object**

Return to the Home Page and find the Sequence in the Object Picker, there. Notice that the **Next Value** column says "1".

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_159.jpg)

### 

**🥋 Query the Sequence**

use role sysadmin;

//See how the nextval function works
select seq_author_uid.nextval;

### 

**🥋 Use the Sequence By Querying It**

Every time you query the sequence, the value will change.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_161.jpg)

Run the query a few more times and see how the next_value changes. When the show sequences result shows next_value = 4, stop and move to the next task.

If you mess up, just recreate the sequence and start over. To recreate any object in Snowflake you can either add "OR REPLACE" to the CREATE SQL statement, or you can drop the object and create it again.

### 

**🥋 Double It Up!**

You can use **nextval** more than once per query. It's not really a common use case, and it's not a common practice, but it's fine to just do it for fun.

Notice that when you do this it skips some numbers. It does this because it is more important for UIDs to be unique than it is for every number to be represented. Run this option several times. We'll be resetting it soon, so you don't need to worry about going too far!

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_162.jpg)

# 

🥋 Reset the Sequence & Add Rows to the Author Table

### 

**📓 Recreate the Sequence with a Different Starting Value**

We will create the sequence again, this time we want it to start counting with the number 3 because there are already 2 rows in the table.

We want the next row we add to our author table to have an AUTHOR_UID of 3.

### 

**🥋 Reset the Sequence then Add Rows to Author**

use role sysadmin;

//Drop and recreate the counter (sequence) so that it starts at 3 
// then we'll add the other author records to our author table
create or replace sequence library_card_catalog.public.seq_author_uid
start = 3 
increment = 1 
ORDER
comment = 'Use this to fill in the AUTHOR_UID every time you add a row';

//Add the remaining author records and use the nextval function instead 
//of putting in the numbers
insert into author(author_uid,first_name, middle_name, last_name) 
values
(seq_author_uid.nextval, 'Laura', 'K','Egendorf')
,(seq_author_uid.nextval, 'Jan', '','Grover')
,(seq_author_uid.nextval, 'Jennifer', '','Clapp')
,(seq_author_uid.nextval, 'Kathleen', '','Petelinsek');

### 

**📓 The NextVal Function**

Before when we added the first two rows to the table, we hard-coded a 1 and a 2 as the row UIDs. This time we use the .nextval function to add UIDs. This will work better in the future because we won't have to remember what number we were on.

It is also possible to use the sequence as part of the table definition the same way we did with the autoincrement property. If we wanted to do that we could define the default value of that column as **seq_author_uid.nextval()**. In our case, we didn't want to start over again so we used the function in the insert statement instead.

🎭 Data Storage: Mapping the Many-to-Many

# 

🥋 Create the Book_To_AUTHOR Table

### 

**🥋 Create the BOOK_TO_AUTHOR Bridge Table**

use database library_card_catalog;
use role sysadmin;


// Create the relationships table
// this is sometimes called a "Many-to-Many table"
create table book_to_author
( book_uid number
  ,author_uid number
);

//Insert rows of the known relationships
insert into book_to_author(book_uid, author_uid)
values
 (1,1)  // This row links the 2001 book to Fiona Macdonald
,(1,2)  // This row links the 2001 book to Gian Paulo Faleschini
,(2,3)  // Links 2006 book to Laura K Egendorf
,(3,4)  // Links 2008 book to Jan Grover
,(4,5)  // Links 2016 book to Jennifer Clapp
,(5,6); // Links 2015 book to Kathleen Petelinsek


//Check your work by joining the 3 tables together
//You should get 1 row for every author
select * 
from book_to_author ba 
join author a 
on ba.author_uid = a.author_uid 
join book b 
on b.book_uid=ba.book_uid;

# 

🤖 DORA DWW15

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE 
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW15' as step 
     ,( select count(*) 
      from LIBRARY_CARD_CATALOG.PUBLIC.Book_to_Author ba 
      join LIBRARY_CARD_CATALOG.PUBLIC.author a 
      on ba.author_uid = a.author_uid 
      join LIBRARY_CARD_CATALOG.PUBLIC.book b 
      on b.book_uid=ba.book_uid) as actual 
     , 6 as expected 
     , '3NF DB was Created.' as description  
); 

### 

🏁 Summary & Next Steps

- To learn more about Snowflake stages, see the [**Managing Snowflake Stages**(opens in a new tab)](https://docs.snowflake.com/en/developer-guide/snowflake-cli/stages/manage-stages)  section in the docs.
    
- For tools to help create ERDs, see this [**Knowledge Base Article**(opens in a new tab)](https://community.snowflake.com/s/article/How-To-Visualize-the-tables-relationship-in-Snowflake) in the community.
    

If you've passed all of the DORA tests up to this point, you're ready to continue!

# 

🎭 Semi-Structured Data Formats

# 

🎯 Create JSON Table & File Format, and Load the File

### 

**🎯 Download a JSON File**

[

author_with_header.json

550 B

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/author_with_header.json)

### 

**🎯 View Your Downloaded JSON File**

Notice the square bracket that surrounds the author records. These brackets could cause all the data to end up in a single row. Be on the lookout for a setting that could make a difference and save us some time.

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_164.png)

### 

**🥋 Create a Table Raw JSON Data**

// JSON DDL Scripts
use database library_card_catalog;
use role sysadmin;

// Create an Ingestion Table for JSON Data
create table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);

### 

**🎯 Create a File Format to Load the JSON Data**

//Create File Format for JSON Data 
create file format library_card_catalog.public.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = <?>
allow_duplicate = <?> 
strip_outer_array = <?>
strip_null_values = <?> 
ignore_utf8_errors = <?>; 

After pasting the code in your worksheet, replace **<?>** with either **TRUE** or **FALSE**.  The default value for each setting is FALSE. To load the file data into separate rows, one of the values will need to be set to TRUE.  **DO NOT USE QUOTES around TRUE and FALSE values.** These are boolean, not strings.

### 

**🎯 Load the Data into the New Table, Using the File Format You Created**

This next step is supposed to be pretty challenging, but it will help you synthesize all that you have learned in a way that very much mimics the work done by Snowflake users on the job.

Remember you can test your file format prior to loading if you query the file using the file format (we did that in **Lesson 9: Staging Data** on the page named 🎯 **Challenge Lab: Create a File Format, Use it in a COPY INTO**, in a section called 🥋 **Explore the Effect of File Formats On Data Interpretation.**

If you don't like the results, modify your file format (there should only be one column, but there should be multiple rows).

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_165.png)

Once you are confident in your file format, create your COPY INTO statement.

Remember that COPY INTO statements require:

- a staged file (file name is listed above, stage name is listed below)
    
- a file format (you just ran the code to create it)
    
- a table to load it into (you just ran the code to create it)
    

Need a syntax reminder? [https://docs.snowflake.com/en/sql-reference/sql/copy-into-table(opens in a new tab)](https://docs.snowflake.com/en/sql-reference/sql/copy-into-table)

Scroll to the bottom of the docs page for examples, if you prefer to see examples.

*Remember your stage? **@util_db.public.my_internal_stage?**

Requires a correct answer to continue

Which file format property, when set to TRUE, has the power to ignore the square brackets and load each author into a separate row?

ENABLE_OCTAL

ALLOW_DUPLICATE

STRIP_OUTER_ARRAY

STRIP_NULL_VALUES

IGNORE_UTF8_ERRORS

SUBMIT

  

### 

**🎯 View the JSON Rows**

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_166.jpg)

# 

🥋 Query the JSON Table

### 

**🥋 Query the JSON Data**

//returns AUTHOR_UID value from top-level object's attribute
select raw_author:AUTHOR_UID
from author_ingest_json;

//returns the data in a way that makes it look like a normalized table
SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;

# 

🤖 DORA DWW16

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW16' as step
  ,( select row_count 
    from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
    where table_name = 'AUTHOR_INGEST_JSON') as actual
  ,6 as expected
  ,'Check number of rows' as description
 );

# 

🎭 Nested JSON

# 

🥋 Load and Query Nested Author & Book JSON Data

### 

**🥋 Create a Table & File Format for Nested JSON Data**

-- create an Ingestion Table for the NESTED JSON Data
create or replace table library_card_catalog.public.nested_ingest_json 
(
  raw_nested_book VARIANT
);

### 

**🎯 Download the Data File for this Lab**

[

json_book_author_nested.txt

956 B

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/json_book_author_nested.txt)

### 

**🎯 Load the Nested JSON File**

Upload the data into the table you just created called NESTED_INGEST_JSON.  You can use the file format you created for the non-nested JSON data.

### 

**🥋 Query the Nested JSON Data**

-- a few simple queries
select raw_nested_book
from nested_ingest_json;

select raw_nested_book:year_published
from nested_ingest_json;

select raw_nested_book:authors
from nested_ingest_json;

### 

**🥋 Use the FLATTEN COMMAND on Nested Data**

-- use these example flatten commands to explore flattening the nested book and author data
select value:first_name
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);

select value:first_name
from nested_ingest_json
,table(flatten(raw_nested_book:authors));

-- add a CAST command to the fields returned
SELECT value:first_name::varchar, value:last_name::varchar
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);

-- assign new column  names to the columns using "AS"
select value:first_name::varchar as first_nm
, value:last_name::varchar as last_nm
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);

# 

🎭 PATH Notation for Nested Entities

# 

🤖 DORA DWW17

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (   
     SELECT 'DWW17' as step 
      ,( select row_count 
        from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
        where table_name = 'NESTED_INGEST_JSON') as actual 
      , 5 as expected 
      ,'Check number of rows' as description  
);

# 

🎭 Some Old Twitter Tweets

# 

🥋 Explore the Data with an Online Parser

### 

**🎯  Download the Data File for this Lab**

[

nutrition_tweets.json

46.6 KB

](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/nutrition_tweets.json)

### 

**🥋 Use an Online Tool to View the JSON Data in the File You Just Downloaded**

OPEN THIS JSON TOOL IN A SEPARATE TAB: [https://jsoneditoronline.org/(opens in a new tab)](https://jsoneditoronline.org/)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_167.png)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_168.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_169.jpg)

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_170.jpg)

Requires a correct answer to continue

How many Tweets are in the file?

5

6

7

8

9

10

11

SUBMIT

  

Requires a correct answer to continue

Which user's tweet included the #Tea hashtag?

Total Well Being (brrsmit406)

Health Tips Ever (HealthTipsEver)

Denon Stacy MS RD LD (rdtipoftheday)

Westside Strength (WSC_Coach)

Satina Cotton (Satin06)

SUBMIT

  

Requires a correct answer to continue

Which user's text talked about making a dessert from beans?

Total Well Being (brrsmit406)

Health Tips Ever (HealthTipsEver)

Denon Stacy MS RD LD (rdtipoftheday)

Westside Strength (WSC_Coach)

Satina Cotton (Satin06)

SUBMIT

# 

🥋 Load and Query Nested TWEET JSON Data

### 

**🎯 Create the Tweets Database Infrastructure**

- Create a database named **SOCIAL_MEDIA_FLOODGATES**
    
- Create a table called **TWEET_INGEST** in the **PUBLIC** schema of your new database. The new table only needs 1 column (you should know the datatype, since this is JSON data). Name the column **RAW_STATUS**
    
- Create a FILE FORMAT that is type JSON that you can use to load the file.
    
- Write a COPY INTO statement that loads the tweet data into the table. You will probably need to stage the file somewhere - you can decide where.
    
- After loading the file, you should end up with 9 separate rows. One tweet per row.
    

### 

**🥋 Run Some Simple Queries on the Nested JSON Tweet Data!**

//simple select statements -- are you seeing 9 rows?
select raw_status
from tweet_ingest;

select raw_status:entities
from tweet_ingest;

select raw_status:entities:hashtags
from tweet_ingest;

//Explore looking at specific hashtags by adding bracketed numbers
//This query returns just the first hashtag in each tweet
select raw_status:entities:hashtags[0].text
from tweet_ingest;

//This version adds a WHERE clause to get rid of any tweet that 
//doesn't include any hashtags
select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;

//Perform a simple CAST on the created_at key
//Add an ORDER BY clause to sort by the tweet's creation date
select raw_status:created_at::date
from tweet_ingest
order by raw_status:created_at::date;

Requires a correct answer to continue

What date was most common for the tweets in the file?

May 10, 2019

June 28, 2019

July 3, 2019

August 22, 2019

September 14, 2019

SUBMIT

# 

🥋 Flatten & Isolate Entities

### 

**🥋 Change the INPUT on the FLATTEN to Isolate an Entity**

//Flatten statements can return nested entities only (and ignore the higher level objects)
select value
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls);

select value
from tweet_ingest
,table(flatten(raw_status:entities:urls));

Requires a correct answer to continue

The two queries above are slightly different in their use of the FLATTEN command.

What affect does this have on the data returned?

The first query returns more URLS.

The second query returns more URLS.

The first query returns more properly formatted data.

The second query returns more properly formatted data.

There doesn't seem to be any difference in the results returned.

SUBMIT

  

### 

**🥋 Query the Nested JSON Tweet Data!**

//Flatten and return just the hashtag text, CAST the text as VARCHAR
select value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);

//Add the Tweet ID and User ID to the returned table so we could join the hashtag back to it's source tweet
select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);

# 

🤖 DORA DWW18

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
   SELECT 'DWW18' as step
  ,( select row_count 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES 
    where table_name = 'TWEET_INGEST') as actual
  , 9 as expected
  ,'Check number of rows' as description  
 );

# 

🥋 Normalize the Hashtags

### 

**🥋 Create a View of the URL Data Looking "Normalized"**

create or replace view social_media_floodgates.public.urls_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:display_url::text as url_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls)
);

### 

**🎯 Create a View that Makes the Hashtag Data Appear Normalized**

- Create a a view called **HASHTAGS_NORMALIZED**.
    
- The results of running a SELECT * on your view should look like the image shown below.
    

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_172.jpg)

# 

🤖 DORA DWW19

### 

**🤖 Run This in Your Worksheet to Send a Report to DORA**

**NEVER EDIT DORA CODE TO GET A GREEN CHECK. EDIT YOUR LAB WORK.**

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW19' as step
  ,( select count(*) 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.VIEWS 
    where table_name = 'HASHTAGS_NORMALIZED') as actual
  , 1 as expected
  ,'Check number of rows' as description
 ); 

To learn more about parsing JSON, see this [**Knowledge Base Article**(opens in a new tab)](https://community.snowflake.com/s/article/json-data-parsing-in-snowflake) in the community.

# 

🎉 Badge Time!

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/DWW_BadgeTime_GIF.gif)

### 

**🎉 It's Badge Time!**

Congratulations! You made it to the end!

As long as you have met all the requirements, your badge will be automatically issued! Staff only gets involved in the rare instance that something in our automated flow has gone wrong. The DWW badge goes out to hundreds of learners every week so please make sure you have checked all requirements and fixed issues on your own. The app is designed to help you help yourself!

### 

**🚀 What's Next?**

If you enjoyed this course, we strongly recommend you move on to our [**Collaboration, Marketplace, & Cost Estimation Workshop (CMCW)**(opens in a new tab)](https://learn.snowflake.com/en/courses/uni-ess-cmcw/).

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/UNI-ESS-CMCW_small.jpg)

CMCW will give you tips for speeding up data loading, and cutting down on development time.

CMCW also covers cost estimation (and basic cost control) which is vital to using Snowflake effectively.

### 

**🤖 Check in with DORA!**

If you've successfully completed all of the DWW DORA Tests, you will be issued the badge for this course.

Take a moment to check in with DORA by logging into the YSA App: [**https://ysa.snowflakeuniversity.com**(opens in a new tab)](https://ysa.snowflakeuniversity.com/)

- **Double-check your email.** Did you spell it correctly?
    
- **Double-check your display name.** Is that how you want it to appear on your badge? You can use accents and any unicode characters so make your name look exactly how you want it to appear!
    
- **Make sure you have a link record** that includes your ACCOUNT ID AND ACCOUNT LOCATOR. Without both pieces of information in the link record, your badge will be blocked.
    
- **Check your record of DORA Lab Checks.**  You should see all DORA Tests (DWW01 to DWW19) listed as both PASSING and VALID.  If you're missing a test, or one of them shows PASSING but NOT VALID, or vice versa, revisit that lesson and re-do the work / re-run the test.
    
- If you did everything above correctly, you will see DWW listed as one of the 'Badges Awarded' entries.
    
- Note that it may take up to an hour before you complete the coursework and when you receive your badge via email notification.
    

You will need your **UNI_ID** and **UUID** to log into the YSA App, which you can find on the course registration page at training.snowflake.com:

![](https://training.snowflake.com/content-server/akamai/content/42/secure/05B7E7790A5049IF392FDFF59155510FCFC0BE93F8625F446DA75D0A13AF599885E0592518AAC2C/media/rco/53/52/8F/6F/34/AC/67/CE/content/scormcontent/assets/p6rYmV/ysa_login_screen.png)

### 

**🎉  Thanks for completing the course, and congratulations!  🎉**