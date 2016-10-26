--Necromantic Summoning
function c77777751.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77777751)
	e1:SetTarget(c77777751.target)
	e1:SetOperation(c77777751.activate)
	c:RegisterEffect(e1)
end


function c77777751.filter(c,e,tp)
	return c:IsSetCard(0x1c8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777751.filter2(c)
	return c:IsSetCard(0x1c8)
end
function c77777751.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingMatchingCard(c77777751.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77777751.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77777751.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		local g2=Duel.GetMatchingGroup(c77777751.filter2,tp,LOCATION_MZONE,0,nil)
		local tc2=g2:GetFirst()
		while tc2 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(300)
			tc2:RegisterEffect(e1)
			tc2=g2:GetNext()
		end
	end
	local g3=Duel.GetMatchingGroup(c77777751.filter2,tp,LOCATION_MZONE,0,nil)
	local tc3=g3:GetFirst()
	while tc3 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc3:RegisterEffect(e1)
		tc3=g3:GetNext()
	end
end
