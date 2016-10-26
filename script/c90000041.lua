--Toxic Waste Maze
function c90000041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Copy Name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c90000041.target)
	e2:SetOperation(c90000041.operation)
	c:RegisterEffect(e2)
	--Damage X2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c90000041.value)
	c:RegisterEffect(e3)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_RECOVER)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c90000041.condition)
	e4:SetTarget(c90000041.target2)
	e4:SetOperation(c90000041.operation2)
	c:RegisterEffect(e4)
	--Self Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c90000041.condition2)
	c:RegisterEffect(e5)
end
function c90000041.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x14)
end
function c90000041.filter2(c)
	return c:IsFaceup() and not c:IsSetCard(0x14)
end
function c90000041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000041.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c90000041.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90000041.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90000041.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c90000041.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and tc:IsRelateToEffect(e) then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(tc:GetCode())
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
  	end
end
function c90000041.value(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return val*2 end
	return val
end
function c90000041.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_EFFECT)~=0 and re and re:GetHandler():GetCode()~=90000041
end
function c90000041.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c90000041.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c90000041.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x14)
end
function c90000041.condition2(e)
	return not Duel.IsExistingMatchingCard(c90000041.filter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,e:GetHandler())
end