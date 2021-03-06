Attribute VB_Name = "Module1"
Sub StockDataKS():
    'code to run on every worksheet
    Dim a As Double
    Dim z As Double
    a = 1
    z = Worksheets.Count
        For a = 1 To z
        Worksheets(a).Activate
                
                'setting up variables for noting the greatest increases/decreases, intializing here so it properly runs
                Dim GreatestIncrease As Double
                Dim GreatestDecrease As Double
                Dim MostVolume As Double
                
                GreatestIncrease = 0
                GreatestDecrease = 2 / 1
                    'setting to 100% so it works
                MostVolume = 0

            'setting up the area to display our findings
            Range("I1").Value = "Ticker"
            Range("I1").Font.Bold = True
            
            Range("J1").Value = "Yearly Change"
            Range("J1").Font.Bold = True
            
            Range("K1").Value = "Percent Change"
            Range("K1").Font.Bold = True
            
            Range("L1").Value = "Total Stock Volume"
            Range("L1").Font.Bold = True
            
            'This will find the total size of the data
            Dim TotalSize As Double
            TotalSize = Range("A1").CurrentRegion.Rows.Count
            
            'This will hold our place as we move through the data.
            Dim PlaceHolder As Double
            PlaceHolder = 2
            
            'Create a Collection variable to keep track of all the tickers in the data
            Dim Tickers As New Collection
            Set Tickers = Nothing
            Dim TickersSize As Double
            TickersSize = 0
            Dim j As Double
            j = 2
            Dim k As Double
            k = 0
            
            Dim DoneFindingAllTickers As Boolean
            DoneFindingAllTickers = False
            ' using a do while loop to go through tickers
            Do While DoneFindingAllTickers = False
                    Application.StatusBar = Tickers.Count
                    If (Tickers.Count = 0) Then
                        'if the tickers collection is empty then it will add the first ticker
                        Tickers.Add (Cells(j, 1).Value)
                        j = j + 1
                    ElseIf (j <= TotalSize) Then
                        'if it hasn't reached the last ticker, then:
                        For v = 1 To Tickers.Count
                            'loops through all the entries in the tickers collection
                            If (Tickers(Tickers.Count) = Cells(j, 1).Value) Then
                                'goes to the next line if the ticker matches the last ticker added- this is an attempt to speed up the code
                                j = j + 1
                            ElseIf (Tickers(v) = Cells(j, 1).Value) Then
                                'if it finds the ticker value, then onto the next row
                                j = j + 1
                            ElseIf (v = Tickers.Count) Then
                                'if its gone through the whole collection and doesn't find it, then add it and go to the next row
                                Tickers.Add (Cells(j, 1).Value)
                                j = j + 1
                            End If
                            Next v
                    ElseIf (j > TotalSize) Then
                        ' after searching all the rows, ends the loop
                        DoneFindingAllTickers = True
                    End If
            Loop
                    
            Dim ActiveTicker As String
            Application.StatusBar = ActiveTicker
            'we will now go through the entire collection of tickers and run the math on them, then print
            For l = 1 To Tickers.Count
                ActiveTicker = Tickers(l)
                'These variables will keep track of where the ticker we're working on starts and stops
                Dim FirstRow As Double
                Dim LastRow As Double
                'First and last date entries
                Dim FirstDate As Double
                Dim LastDate As Double
                'Variables to keep track of the first and last prices
                Dim FirstPrice As Double
                Dim LastPrice As Double
                'Initalizing LastDate in the farflung future or else it will just return 0
                FirstDate = 22280322
                LastDate = 0
                FirstPrice = 0
                LastPrice = 0
                'This will tell us how many of the active ticker we have
                Dim HowManyActiveTicker As Double
                HowManyActiveTicker = Application.WorksheetFunction.CountIf(Columns(1), ActiveTicker)
                
                If (VarType(Application.Match(ActiveTicker, Columns(1), 0)) = 10) Then
                    'error capture, shouldn't affect anything
                Else
                    PlaceHolder = Application.Match(ActiveTicker, Columns(1), 0)
                End If
                
                'Tracking Volume
                Dim TotalVolume As Double
                TotalVolume = 0
                'Cycles through all the active ticker selection to find the first and last date entries
                For i = PlaceHolder To (PlaceHolder + HowManyActiveTicker - 1)
                    If (Cells(i, 2).Value < FirstDate) Then
                        FirstDate = Cells(i, 2).Value
                        FirstPrice = Cells(i, 3).Value
                    ElseIf (Cells(i, 2).Value > LastDate) Then
                        LastDate = Cells(i, 2).Value
                        LastPrice = Cells(i, 6).Value
                    End If
                    TotalVolume = TotalVolume + Cells(i, 7).Value
                    Next i
                
                       
                'setting up variables for greatest increase, greatest decrease and most volume
                Dim GreatestIncreaseTicker As String
                Dim GreatestDecreaseTicker As String
                Dim MostVolumeTicker As String
                
                
                If (VarType(Application.Match(ActiveTicker, Columns(1), 0)) = 10) Then
                    'error capture, shouldn't affect anything
                Else
                    'Printing the results
                    Cells(l + 1, 9).Value = ActiveTicker
                    Cells(l + 1, 10).Value = LastPrice - FirstPrice
                        If (Cells(l + 1, 10).Value > 0) Then
                            Cells(l + 1, 10).Interior.ColorIndex = 4
                        ElseIf (Cells(l + 1, 10).Value < 0) Then
                            Cells(l + 1, 10).Interior.ColorIndex = 3
                        End If
                    
                        If (FirstPrice = 0) Then
                            Cells(l + 1, 11).Value = FormatPercent(0)
                        Else
                            Cells(l + 1, 11).Value = FormatPercent((LastPrice / FirstPrice) - 1)
                    End If
                    
                Cells(l + 1, 12).Value = TotalVolume
                End If
                
                
                
                Cells(2, 14).Value = "Greatest % Increase"
                Cells(3, 14).Value = "Greatest % Decrease"
                Cells(4, 14).Value = "Greatest Total Volume"
                
                ' finds and prints the greatest increase, greatest decrease and most volume
                If (FirstPrice = 0) Then
                    'skip- this fixed a bug where some tickers that had all zeros would crash the program
                ElseIf (((LastPrice / FirstPrice) - 1) > GreatestIncrease) Then
                    GreatestIncrease = (LastPrice / FirstPrice) - 1
                    Cells(2, 15).Value = FormatPercent(GreatestIncrease)
                    GreatestIncreaseTicker = ActiveTicker
                    Cells(2, 16).Value = GreatestIncreaseTicker
                End If
                If (FirstPrice = 0) Then
                    'skip
                ElseIf (((LastPrice / FirstPrice) - 1) < GreatestDecrease) Then
                    GreatestDecrease = (LastPrice / FirstPrice) - 1
                    Cells(3, 15).Value = FormatPercent(GreatestDecrease)
                    GreatestDecreaseTicker = ActiveTicker
                    Cells(3, 16).Value = GreatestDecreaseTicker
                End If
                If (TotalVolume > MostVolume) Then
                    MostVolume = TotalVolume
                    Cells(4, 15).Value = MostVolume
                    MostVolumeTicker = ActiveTicker
                    Cells(4, 16).Value = MostVolumeTicker
                End If
            
            Next l
            
            
            'resizing columns because data spilling over into the next column drives me crazy
            Range("I2:L2").EntireColumn.AutoFit
            Range("N2:P4").EntireColumn.AutoFit

    Next a
    
End Sub

