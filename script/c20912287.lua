--Last Stand of the Sword Artists
function c20912287.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912287,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,20912287+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c20912287.condition)
	e1:SetTarget(c20912287.target)
	e1:SetOperation(c20912287.activate)
	c:RegisterEffect(e1)
end
function c20912287.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)-3000
end
function c20912287.xyzfilter1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xd0a2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c20912287.xyzfilter2(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ)
end
function c20912287.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c20912287.xyzfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c20912287.xyzfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c20912287.xyzfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c20912287.xyzfilter2,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c20912287.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end