import streamlit as st
import mysql.connector
from mysql.connector import Error
import pandas as pd

# Database connection parameters
DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASSWORD = 'admin123456@'  # Set your MySQL password
DB_NAME = 'inventory'

# Helper function to connect to the database
def get_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )

# Helper to run a query and return DataFrame
def run_query(query, params=None):
    conn = get_connection()
    df = pd.DataFrame()
    try:
        df = pd.read_sql(query, conn, params=params)
    except Exception as e:
        st.error(f"Error: {e}")
    finally:
        conn.close()
    return df

# Helper to execute a command (insert/update/delete)
def run_command(query, params=None):
    conn = get_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(query, params)
        conn.commit()
        return True, None
    except Exception as e:
        return False, str(e)
    finally:
        conn.close()

# Sidebar navigation
st.sidebar.title("Inventory Management")
menu = st.sidebar.selectbox(
    "Select Operation",
    [
        "View Categories", "Add Category", "Update Category", "Delete Category",
        "View Suppliers", "Add Supplier", "Update Supplier", "Delete Supplier",
        "View Products", "Add Product", "Update Product", "Delete Product",
        "View Purchases", "Add Purchase", "Update Purchase", "Delete Purchase",
        "View Sales", "Add Sale", "Update Sale", "Delete Sale",
        "Monthly Sales Report"
    ]
)

# --- Categories ---
if menu == "View Categories":
    st.header("Categories")
    df = run_query("SELECT * FROM categories")
    st.dataframe(df)

elif menu == "Add Category":
    st.header("Add Category")
    with st.form("add_cat"):
        name = st.text_input("Name")
        desc = st.text_area("Description")
        submitted = st.form_submit_button("Add")
        if submitted:
            ok, err = run_command(
                "INSERT INTO categories (name, description) VALUES (%s, %s)",
                (name, desc)
            )
            if ok:
                st.success("Category added.")
            else:
                st.error(err)

elif menu == "Update Category":
    st.header("Update Category")
    df = run_query("SELECT * FROM categories")
    if not df.empty:
        cat = st.selectbox("Select Category", df["name"])
        row = df[df["name"] == cat].iloc[0]
        with st.form("upd_cat"):
            name = st.text_input("Name", value=row["name"])
            desc = st.text_area("Description", value=row["description"])
            submitted = st.form_submit_button("Update")
            if submitted:
                ok, err = run_command(
                    "UPDATE categories SET name=%s, description=%s WHERE category_id=%s",
                    (name, desc, row["category_id"])
                )
                if ok:
                    st.success("Category updated.")
                else:
                    st.error(err)
    else:
        st.info("No categories to update.")

elif menu == "Delete Category":
    st.header("Delete Category")
    df = run_query("SELECT * FROM categories")
    if not df.empty:
        cat = st.selectbox("Select Category", df["name"])
        row = df[df["name"] == cat].iloc[0]
        if st.button("Delete"):
            ok, err = run_command(
                "DELETE FROM categories WHERE category_id=%s",
                (row["category_id"],)
            )
            if ok:
                st.success("Category deleted.")
            else:
                st.error(err)
    else:
        st.info("No categories to delete.")

# --- Suppliers ---
if menu == "View Suppliers":
    st.header("Suppliers")
    df = run_query("SELECT * FROM suppliers")
    st.dataframe(df)

elif menu == "Add Supplier":
    st.header("Add Supplier")
    with st.form("add_sup"):
        name = st.text_input("Name")
        contact = st.text_input("Contact Name")
        phone = st.text_input("Phone")
        email = st.text_input("Email")
        address = st.text_area("Address")
        submitted = st.form_submit_button("Add")
        if submitted:
            ok, err = run_command(
                "INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES (%s, %s, %s, %s, %s)",
                (name, contact, phone, email, address)
            )
            if ok:
                st.success("Supplier added.")
            else:
                st.error(err)

elif menu == "Update Supplier":
    st.header("Update Supplier")
    df = run_query("SELECT * FROM suppliers")
    if not df.empty:
        sup = st.selectbox("Select Supplier", df["name"])
        row = df[df["name"] == sup].iloc[0]
        with st.form("upd_sup"):
            name = st.text_input("Name", value=row["name"])
            contact = st.text_input("Contact Name", value=row["contact_name"])
            phone = st.text_input("Phone", value=row["phone"])
            email = st.text_input("Email", value=row["email"])
            address = st.text_area("Address", value=row["address"])
            submitted = st.form_submit_button("Update")
            if submitted:
                ok, err = run_command(
                    "UPDATE suppliers SET name=%s, contact_name=%s, phone=%s, email=%s, address=%s WHERE supplier_id=%s",
                    (name, contact, phone, email, address, row["supplier_id"])
                )
                if ok:
                    st.success("Supplier updated.")
                else:
                    st.error(err)
    else:
        st.info("No suppliers to update.")

elif menu == "Delete Supplier":
    st.header("Delete Supplier")
    df = run_query("SELECT * FROM suppliers")
    if not df.empty:
        sup = st.selectbox("Select Supplier", df["name"])
        row = df[df["name"] == sup].iloc[0]
        if st.button("Delete"):
            ok, err = run_command(
                "DELETE FROM suppliers WHERE supplier_id=%s",
                (row["supplier_id"],)
            )
            if ok:
                st.success("Supplier deleted.")
            else:
                st.error(err)
    else:
        st.info("No suppliers to delete.")

# --- Products ---
if menu == "View Products":
    st.header("Products")
    df = run_query("SELECT * FROM products")
    st.dataframe(df)

elif menu == "Add Product":
    st.header("Add Product")
    cats = run_query("SELECT category_id, name FROM categories")
    sups = run_query("SELECT supplier_id, name FROM suppliers")
    with st.form("add_prod"):
        name = st.text_input("Name")
        cat = st.selectbox("Category", cats["name"]) if not cats.empty else None
        sup = st.selectbox("Supplier", sups["name"]) if not sups.empty else None
        price = st.number_input("Unit Price", min_value=0.0, step=0.01)
        stock = st.number_input("Units in Stock", min_value=0)
        reorder = st.number_input("Reorder Level", min_value=0)
        submitted = st.form_submit_button("Add")
        if submitted and cat and sup:
            cat_id = int(cats[cats["name"] == cat]["category_id"].iloc[0])
            sup_id = int(sups[sups["name"] == sup]["supplier_id"].iloc[0])
            ok, err = run_command(
                "INSERT INTO products (name, category_id, supplier_id, unit_price, units_in_stock, reorder_level) VALUES (%s, %s, %s, %s, %s, %s)",
                (name, cat_id, sup_id, price, stock, reorder)
            )
            if ok:
                st.success("Product added.")
            else:
                st.error(err)

elif menu == "Update Product":
    st.header("Update Product")
    df = run_query("SELECT * FROM products")
    cats = run_query("SELECT category_id, name FROM categories")
    sups = run_query("SELECT supplier_id, name FROM suppliers")
    if not df.empty:
        prod = st.selectbox("Select Product", df["name"])
        row = df[df["name"] == prod].iloc[0]
        with st.form("upd_prod"):
            name = st.text_input("Name", value=row["name"])
            cat = st.selectbox("Category", cats["name"], index=cats[cats["category_id"] == row["category_id"]].index[0])
            sup = st.selectbox("Supplier", sups["name"], index=sups[sups["supplier_id"] == row["supplier_id"]].index[0])
            price = st.number_input("Unit Price", min_value=0.0, step=0.01, value=float(row["unit_price"]))
            stock = st.number_input("Units in Stock", min_value=0, value=int(row["units_in_stock"]))
            reorder = st.number_input("Reorder Level", min_value=0, value=int(row["reorder_level"]))
            submitted = st.form_submit_button("Update")
            if submitted:
                cat_id = int(cats[cats["name"] == cat]["category_id"].iloc[0])
                sup_id = int(sups[sups["name"] == sup]["supplier_id"].iloc[0])
                ok, err = run_command(
                    "UPDATE products SET name=%s, category_id=%s, supplier_id=%s, unit_price=%s, units_in_stock=%s, reorder_level=%s WHERE product_id=%s",
                    (name, cat_id, sup_id, price, stock, reorder, row["product_id"])
                )
                if ok:
                    st.success("Product updated.")
                else:
                    st.error(err)
    else:
        st.info("No products to update.")

elif menu == "Delete Product":
    st.header("Delete Product")
    df = run_query("SELECT * FROM products")
    if not df.empty:
        prod = st.selectbox("Select Product", df["name"])
        row = df[df["name"] == prod].iloc[0]
        if st.button("Delete"):
            ok, err = run_command(
                "DELETE FROM products WHERE product_id=%s",
                (row["product_id"],)
            )
            if ok:
                st.success("Product deleted.")
            else:
                st.error(err)
    else:
        st.info("No products to delete.")

# --- Purchases ---
if menu == "View Purchases":
    st.header("Purchases")
    df = run_query("SELECT * FROM purchases")
    st.dataframe(df)

elif menu == "Add Purchase":
    st.header("Add Purchase")
    prods = run_query("SELECT product_id, name FROM products")
    sups = run_query("SELECT supplier_id, name FROM suppliers")
    with st.form("add_pur"):
        prod = st.selectbox("Product", prods["name"]) if not prods.empty else None
        sup = st.selectbox("Supplier", sups["name"]) if not sups.empty else None
        qty = st.number_input("Quantity", min_value=1)
        date = st.date_input("Purchase Date")
        submitted = st.form_submit_button("Add")
        if submitted and prod and sup:
            prod_id = int(prods[prods["name"] == prod]["product_id"].iloc[0])
            sup_id = int(sups[sups["name"] == sup]["supplier_id"].iloc[0])
            ok, err = run_command(
                "INSERT INTO purchases (product_id, supplier_id, quantity, purchase_date) VALUES (%s, %s, %s, %s)",
                (prod_id, sup_id, qty, date)
            )
            if ok:
                st.success("Purchase added.")
            else:
                st.error(err)

elif menu == "Update Purchase":
    st.header("Update Purchase")
    df = run_query("SELECT * FROM purchases")
    prods = run_query("SELECT product_id, name FROM products")
    sups = run_query("SELECT supplier_id, name FROM suppliers")
    if not df.empty:
        pur_id = st.selectbox("Select Purchase ID", df["purchase_id"])
        row = df[df["purchase_id"] == pur_id].iloc[0]
        with st.form("upd_pur"):
            prod = st.selectbox("Product", prods["name"], index=prods[prods["product_id"] == row["product_id"]].index[0])
            sup = st.selectbox("Supplier", sups["name"], index=sups[sups["supplier_id"] == row["supplier_id"]].index[0])
            qty = st.number_input("Quantity", min_value=1, value=int(row["quantity"]))
            date = st.date_input("Purchase Date", value=row["purchase_date"])
            submitted = st.form_submit_button("Update")
            if submitted:
                prod_id = int(prods[prods["name"] == prod]["product_id"].iloc[0])
                sup_id = int(sups[sups["name"] == sup]["supplier_id"].iloc[0])
                ok, err = run_command(
                    "UPDATE purchases SET product_id=%s, supplier_id=%s, quantity=%s, purchase_date=%s WHERE purchase_id=%s",
                    (prod_id, sup_id, qty, date, pur_id)
                )
                if ok:
                    st.success("Purchase updated.")
                else:
                    st.error(err)
    else:
        st.info("No purchases to update.")

elif menu == "Delete Purchase":
    st.header("Delete Purchase")
    df = run_query("SELECT * FROM purchases")
    if not df.empty:
        pur_id = st.selectbox("Select Purchase ID", df["purchase_id"])
        if st.button("Delete"):
            ok, err = run_command(
                "DELETE FROM purchases WHERE purchase_id=%s",
                (pur_id,)
            )
            if ok:
                st.success("Purchase deleted.")
            else:
                st.error(err)
    else:
        st.info("No purchases to delete.")

# --- Sales ---
if menu == "View Sales":
    st.header("Sales")
    df = run_query("SELECT * FROM sales")
    st.dataframe(df)

elif menu == "Add Sale":
    st.header("Add Sale")
    prods = run_query("SELECT product_id, name FROM products")
    with st.form("add_sale"):
        prod = st.selectbox("Product", prods["name"]) if not prods.empty else None
        qty = st.number_input("Quantity", min_value=1)
        date = st.date_input("Sale Date")
        submitted = st.form_submit_button("Add")
        if submitted and prod:
            prod_id = int(prods[prods["name"] == prod]["product_id"].iloc[0])
            ok, err = run_command(
                "INSERT INTO sales (product_id, quantity, sale_date) VALUES (%s, %s, %s)",
                (prod_id, qty, date)
            )
            if ok:
                st.success("Sale added.")
            else:
                st.error(err)

elif menu == "Update Sale":
    st.header("Update Sale")
    df = run_query("SELECT * FROM sales")
    prods = run_query("SELECT product_id, name FROM products")
    if not df.empty:
        sale_id = st.selectbox("Select Sale ID", df["sale_id"])
        row = df[df["sale_id"] == sale_id].iloc[0]
        with st.form("upd_sale"):
            prod = st.selectbox("Product", prods["name"], index=prods[prods["product_id"] == row["product_id"]].index[0])
            qty = st.number_input("Quantity", min_value=1, value=int(row["quantity"]))
            date = st.date_input("Sale Date", value=row["sale_date"])
            submitted = st.form_submit_button("Update")
            if submitted:
                prod_id = int(prods[prods["name"] == prod]["product_id"].iloc[0])
                ok, err = run_command(
                    "UPDATE sales SET product_id=%s, quantity=%s, sale_date=%s WHERE sale_id=%s",
                    (prod_id, qty, date, sale_id)
                )
                if ok:
                    st.success("Sale updated.")
                else:
                    st.error(err)
    else:
        st.info("No sales to update.")

elif menu == "Delete Sale":
    st.header("Delete Sale")
    df = run_query("SELECT * FROM sales")
    if not df.empty:
        sale_id = st.selectbox("Select Sale ID", df["sale_id"])
        if st.button("Delete"):
            ok, err = run_command(
                "DELETE FROM sales WHERE sale_id=%s",
                (sale_id,)
            )
            if ok:
                st.success("Sale deleted.")
            else:
                st.error(err)
    else:
        st.info("No sales to delete.")

# --- Reports ---
if menu == "Monthly Sales Report":
    st.header("Monthly Sales Report")
    df = run_query("SELECT * FROM monthly_sales_report")
    st.dataframe(df) 