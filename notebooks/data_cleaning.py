import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the datasets from your working directory
print("Loading datasets...")
df_table = pd.read_csv('UCI table.csv')
df_database = pd.read_csv('UCI database.csv')

print(f"--- DATASET SHAPES ---")
print(f"UCI table shape: {df_table.shape}")
print(f"UCI database shape: {df_database.shape}\n")

# Clean and inspect missing values in the main table
print("--- CLEANING & MISSING VALUES ---")
missing_values = df_table.isnull().sum()
print(missing_values[missing_values > 0])

# Handle Missing Values 
print("\nCleaning missing values...")
df_table['Data Types'] = df_table['Data Types'].fillna('Unknown')
df_table['Attribute Types'] = df_table['Attribute Types'].fillna('Unknown')
median_year = df_table['Year'].median()
df_table['Year'] = df_table['Year'].fillna(median_year)
df_table['Number of Attributes'] = df_table['Number of Attributes'].fillna(df_table['Number of Attributes'].median())

# Verify that 0 missing values remain
remaining_missing = df_table.isnull().sum().sum()
print(f"Total missing values remaining: {remaining_missing}")
print(f"Cleaned dataset shape: {df_table.shape}")


# Set the visual style
sns.set_theme(style="whitegrid")

# Group data by Year to see dataset publication trends
yearly_counts = df_table.groupby('Year').size().reset_index(name='Dataset_Count')

# Create the line plot
plt.figure(figsize=(10, 6))
sns.lineplot(data=yearly_counts, x='Year', y='Dataset_Count', marker='o', color='b', linewidth=2.5)

# Add titles and labels
plt.title('Growth of UCI Machine Learning Datasets Over Time', fontsize=14, fontweight='bold')
plt.xlabel('Publication Year', fontsize=11)
plt.ylabel('Number of Datasets Published', fontsize=11)

# Save and display the chart
plt.savefig('uci_dataset_growth.png', dpi=300, bbox_inches='tight')
print("\nSuccess! Chart saved as 'uci_dataset_growth.png' in your project folder.")

plt.show()