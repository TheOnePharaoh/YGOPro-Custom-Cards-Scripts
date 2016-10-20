--Little Fat Cat, Corazon
function c77790021.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,77790021+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c77790021.cttg)
	e2:SetOperation(c77790021.ctop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c77790021.sptg)
	e3:SetOperation(c77790021.spop)
	c:RegisterEffect(e3)
end
function c77790021.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c77790021.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0xfe0000)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
   			Duel.BreakEffect()
		end
	end
end
function c77790021.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:GetLevel()<=5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77790021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77790021.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77790021.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
