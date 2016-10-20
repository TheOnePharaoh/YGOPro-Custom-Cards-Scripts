--Bloodline Flow Boost
function c888000033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c888000033.condition)
	e1:SetTarget(c888000033.target)
	e1:SetOperation(c888000033.activate)
	c:RegisterEffect(e1)
end
function c888000033.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>1
end
function c888000033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c888000033.blfilter(c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end
function c888000033.vnfilter(c)
	return c:IsSetCard(0x888) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c888000033.vnfilter2(c,e,tp)
	return c:IsSetCard(0x888) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c888000033.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c888000033.nefilter(c)
	return not c:IsLocation(LOCATION_EXTRA)
end
function c888000033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	Duel.Draw(tp,2,REASON_EFFECT)
	if tc1 and tc2 then
		Duel.ConfirmCards(1-tp,g)
		if (c888000033.blfilter(tc1) or c888000033.blfilter(tc2)) and not c888000033.vnfilter(tc1) and not c888000033.vnfilter(tc2) then
			local rd=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=rd:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		elseif c888000033.vnfilter2(tc1,e,tp) or c888000033.vnfilter2(tc2,e,tp) then
			local mg=Duel.GetRitualMaterial(tp)
			local mg2=Duel.GetMatchingGroup(c888000033.mfilter,tp,LOCATION_EXTRA,0,nil)
			mg:Merge(mg2)
			mg:Sub(g)
			if c888000033.vnfilter2(tc1,e,tp) and c888000033.vnfilter2(tc2,e,tp) then
				local lv1=tc1:GetLevel()
				local lv2=tc2:GetLevel()
				local lvt=lv1+lv2
				local a=mg:CheckWithSumEqual(Card.GetRitualLevel,lv1,1,99,tc1)
				local b=mg:CheckWithSumEqual(Card.GetRitualLevel,lv2,1,99,tc2)
				local c=mg:CheckWithSumEqual(Card.GetLevel,lvt,1,99)
				if not a and not b and not c then
					local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
					Duel.SendtoGrave(sg,REASON_EFFECT)
					return
				end
				if Duel.SelectYesNo(tp,aux.Stringid(57554544,1)) then
					local rmat=Group.CreateGroup()
					local tmat=Group.CreateGroup()
					local rlv=0
					local tlv1=0
					local tlv2=0
					if a and b and c then
						if lv1>lv2 then lv1,lv2=lv2,lv1 end
						while tlv1~=lv1 and tlv2~=lv1 and tlv1~=lv2 and tlv2~=lv2 and tlv1~=lvt and tlv2~=lvt do
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
							tmat=mg:Select(tp,1,99,nil)
							tlv1=tmat:GetSum(Card.GetRitualLevel,tc1)
							tlv2=tmat:GetSum(Card.GetRitualLevel,tc2)
						end
						rmat:Merge(tmat)
						tc1:SetMaterial(rmat)
						tc2:SetMaterial(rmat)
						local g2=rmat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
						rmat=rmat:Filter(c888000033.nefilter,nil)
						Duel.ReleaseRitualMaterial(rmat)
						Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					elseif a and b then
						if lv1>lv2 then lv1,lv2=lv2,lv1 end
						while tlv1~=lv1 and tlv2~=lv1 and tlv1~=lv2 and tlv2~=lv2 do
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
							tmat=mg:Select(tp,1,99,nil)
							tlv1=tmat:GetSum(Card.GetRitualLevel,tc1)
							tlv2=tmat:GetSum(Card.GetRitualLevel,tc2)
						end
						rmat:Merge(tmat)
						rlv=tlv1
						tlv1=0
						tlv2=0
						mg:Sub(tmat)
						lv2=lv2-rlv
						if (mg:CheckWithSumEqual(Card.GetRitualLevel,lv2,1,99,tc1) or mg:CheckWithSumEqual(Card.GetRitualLevel,lv2,1,99,tc2)) 
							and Duel.SelectYesNo(tp,aux.Stringid(888000033,1)) then
							while tlv1~=lv2 and tlv2~=lv2 do
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
								tmat=mg:Select(tp,1,99,nil)
								tlv1=tmat:GetSum(Card.GetRitualLevel,tc1)
								tlv2=tmat:GetSum(Card.GetRitualLevel,tc2)
							end
							rmat:Merge(tmat)
						end
						tc1:SetMaterial(rmat)
						tc2:SetMaterial(rmat)
						local g2=rmat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
						rmat=rmat:Filter(c888000033.nefilter,nil)
						Duel.ReleaseRitualMaterial(rmat)
						Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					elseif a and c then
						while tlv1~=lv1 and tlv2~=lv1 and tlv1~=lvt and tlv2~=lvt do
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
							tmat=mg:Select(tp,1,99,nil)
							tlv1=tmat:GetSum(Card.GetRitualLevel,tc1)
							tlv2=tmat:GetSum(Card.GetRitualLevel,tc2)
						end
						rmat:Merge(tmat)
						rlv=tlv1
						tlv1=0
						tlv2=0
						mg:Sub(tmat)
						lvt=lvt-rlv
						if (mg:CheckWithSumEqual(Card.GetRitualLevel,lvt,1,99,tc1) or mg:CheckWithSumEqual(Card.GetRitualLevel,lvt,1,99,tc2)) 
							and Duel.SelectYesNo(tp,aux.Stringid(888000033,1)) then
							while tlv1~=lvt and tlv2~=lvt do
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
								tmat=mg:Select(tp,1,99,nil)
								tlv1=tmat:GetSum(Card.GetRitualLevel,tc1)
								tlv2=tmat:GetSum(Card.GetRitualLevel,tc2)
							end
							rmat:Merge(tmat)
						end
						tc1:SetMaterial(rmat)
						tc2:SetMaterial(rmat)
						local g2=rmat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
						rmat=rmat:Filter(c888000033.nefilter,nil)
						Duel.ReleaseRitualMaterial(rmat)
						Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					elseif b and c then
						while tlv1~=lv2 and tlv2~=lv2 and tlv1~=lvt and tlv2~=lvt do
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
							tmat=mg:Select(tp,1,99,nil)
							tlv1=tmat:GetSum(Card.GetRitualLevel,tc1)
							tlv2=tmat:GetSum(Card.GetRitualLevel,tc2)
						end
						rmat:Merge(tmat)
						rlv=tlv1
						tlv1=0
						tlv2=0
						mg:Sub(tmat)
						lvt=lvt-rlv
						if (mg:CheckWithSumEqual(Card.GetRitualLevel,lvt,1,99,tc1) or mg:CheckWithSumEqual(Card.GetRitualLevel,lvt,1,99,tc2)) 
							and Duel.SelectYesNo(tp,aux.Stringid(888000033,1)) then
							while tlv1~=lvt and tlv2~=lvt do
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
								tmat=mg:Select(tp,1,99,nil)
								tlv1=tmat:GetSum(Card.GetRitualLevel,tc1)
								tlv2=tmat:GetSum(Card.GetRitualLevel,tc2)
							end
							rmat:Merge(tmat)
						end
						tc1:SetMaterial(rmat)
						tc2:SetMaterial(rmat)
						local g2=rmat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
						rmat=rmat:Filter(c888000033.nefilter,nil)
						Duel.ReleaseRitualMaterial(rmat)
						Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					elseif a then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,lv1,1,99,tc1)
						tc1:SetMaterial(mat)
						tc2:SetMaterial(mat)
						local g2=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
						mg=mg:Filter(c888000033.nefilter,nil)
						Duel.ReleaseRitualMaterial(mat)
						Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					elseif b then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,lv2,1,99,tc2)
						tc1:SetMaterial(mat)
						tc2:SetMaterial(mat)
						local g2=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
						mg=mg:Filter(c888000033.nefilter,nil)
						Duel.ReleaseRitualMaterial(mat)
						Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					elseif c then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,lvt,1,99)
						tc1:SetMaterial(mat)
						tc2:SetMaterial(mat)
						Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					end
				else
					local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
					Duel.SendtoGrave(sg,REASON_EFFECT)
					return
				end
				Duel.SpecialSummonStep(tc1,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc1:CompleteProcedure()
				Duel.SpecialSummonStep(tc2,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc2:CompleteProcedure()
				Duel.SpecialSummonComplete()
			elseif c888000033.vnfilter2(tc1,e,tp) and not c888000033.vnfilter2(tc2,e,tp) then
				if mg:CheckWithSumEqual(Card.GetRitualLevel,tc1:GetLevel(),1,99,tc1) 
					and Duel.SelectYesNo(tp,aux.Stringid(57554544,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc1:GetLevel(),1,99,tc1)
					tc1:SetMaterial(mat)
					local g2=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
					mg=mg:Filter(c888000033.nefilter,nil)
					Duel.ReleaseRitualMaterial(mat)
					Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					Duel.SpecialSummonStep(tc1,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc1:CompleteProcedure()
					Duel.SpecialSummonComplete()
				else
					local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
					Duel.SendtoGrave(sg,REASON_EFFECT)
					return
				end
			elseif not c888000033.vnfilter2(tc1,e,tp) and c888000033.vnfilter2(tc2,e,tp) then
				if mg:CheckWithSumEqual(Card.GetRitualLevel,tc2:GetLevel(),1,99,tc2) 
					and Duel.SelectYesNo(tp,aux.Stringid(57554544,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc2:GetLevel(),1,99,tc2)
					tc1:SetMaterial(mat)
					local g2=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
					mg=mg:Filter(c888000033.nefilter,nil)
					Duel.ReleaseRitualMaterial(mat)
					Duel.SendtoGrave(g2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					Duel.SpecialSummonStep(tc2,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc1:CompleteProcedure()
					Duel.SpecialSummonComplete()
				else
					local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
					Duel.SendtoGrave(sg,REASON_EFFECT)
					return
				end
			end
		else
			local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
