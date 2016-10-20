--Vocaloids Demolition
function c77662917.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77662917.cost)
	e1:SetTarget(c77662917.target)
	e1:SetOperation(c77662917.activate)
	c:RegisterEffect(e1)
end
function c77662917.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c77662917.filter(c,cst)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and (not cst or c:GetOverlayCount()~=0)
end
function c77662917.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chkcost=e:GetLabel()==1 and true or false
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77662917.filter(chkc,chkcost) end
	if chk==0 then
		e:SetLabel(0)
		return Duel.IsExistingTarget(c77662917.filter,tp,LOCATION_MZONE,0,1,nil,chkcost)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c77662917.filter,tp,LOCATION_MZONE,0,1,1,nil,chkcost):GetFirst()
	if chkcost then
		tc:RemoveOverlayCard(tp,tc:GetOverlayCount(),tc:GetOverlayCount(),REASON_COST)
	end
end
function c77662917.filter2(c)
	return not c:IsRace(RACE_MACHINE) and c:IsDestructable()
end
function c77662917.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77662917.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
