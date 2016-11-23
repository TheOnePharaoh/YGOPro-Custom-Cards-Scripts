--Seasonal Feathers - Song of Eternal Happiness
function c8721.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8721+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c8721.target)
	e1:SetOperation(c8721.activate)
	c:RegisterEffect(e1)
end
function c8721.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x0dac404) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8721.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac406) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c8721.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c8721.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c8721.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c8721.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c8721.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c8721.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end
