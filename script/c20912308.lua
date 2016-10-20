--Familiar Re-Forge
function c20912308.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20912308.cost)
	e1:SetTarget(c20912308.target)
	e1:SetOperation(c20912308.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c20912308.reptg)
	e2:SetValue(c20912308.repval)
	c:RegisterEffect(e2)
end
function c20912308.thacfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function c20912308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912308.thacfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c20912308.thacfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c20912308.filter(c,e,tp)
	return c:IsSetCard(0xd0a3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c20912308.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c20912308.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c20912308.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c20912308.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c20912308.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c20912308.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(0xd0a2) and c:IsReason(REASON_EFFECT)
end
function c20912308.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c20912308.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(20912308,0)) then
		local g=eg:Filter(c20912308.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c20912308.repval(e,c)
	return c==e:GetLabelObject()
end