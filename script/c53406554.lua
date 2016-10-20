--Vocalist Love Gift
function c53406554.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53406554)
	e1:SetTarget(c53406554.rectg)
	e1:SetOperation(c53406554.recop)
	c:RegisterEffect(e1)
end
function c53406554.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO)
end
function c53406554.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c53406554.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*600)
end
function c53406554.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c53406554.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*600,REASON_EFFECT)
end
