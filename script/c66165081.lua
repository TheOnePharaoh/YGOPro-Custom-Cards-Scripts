--The Legendary Frost Golem
function c66165081.initial_effect(c)
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c66165081.atkfilter)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c66165081.regcon)
	e2:SetOperation(c66165081.regop)
	c:RegisterEffect(e2)
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c66165081.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,66165081)
	e4:SetCondition(c66165081.atkcon)
	e4:SetTarget(c66165081.atktg)
	e4:SetOperation(c66165081.atkop)
	c:RegisterEffect(e4)
end
function c66165081.atkfilter(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c66165081.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xea010) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c66165081.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE and e:GetLabel()==1
end
function c66165081.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66165081,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c66165081.destg)
	e1:SetOperation(c66165081.desop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c66165081.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and bit.band(tc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c66165081.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c66165081.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165081.atckfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c66165081.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66165081.atckfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c66165081.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c66165081.atckfilter,tp,LOCATION_MZONE,0,nil)
	local atk=sg:GetCount()*300
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end