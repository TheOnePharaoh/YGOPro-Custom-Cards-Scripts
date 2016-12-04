--Created and Scripted by THEPHARAOH
--Venomus flowers bloom
function c96100573.initial_effect(c)
	--Activate
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1353770,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c96100573.condition)
	e1:SetTarget(c96100573.target)
	e1:SetOperation(c96100573.operation)
	c:RegisterEffect(e1)
end

function c96100573.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c96100573.filter(c,e,sp)
	return c:IsSetCard(0x10f3) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c96100573.ffilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c96100573.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c96100573.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c96100573.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96100573.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,2,2,nil,e,tp)
	if g:GetCount()>1 then
		local tc=g:GetFirst()
		while tc do
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc=g:GetNext()
		end
	end
	 if Duel.IsExistingMatchingCard(c96100573.ffilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(96100573,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local f=Duel.SelectMatchingCard(tp,c96100573.ffilter,tp,LOCATION_DECK,0,1,1,nil)
	if f:GetCount()>0 then
		Duel.SendtoHand(f,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,f)
	end
	end
end
