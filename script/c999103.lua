--Dark Mystical Slate Warrior
function c999103.initial_effect(c)
	c:SetUniqueOnField(1,0,999103)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,999102),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--avoid damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c999103.damval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	--spell cannot be negated
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c999103.chainfilter)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_DISEFFECT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c999103.chainfilter)
	c:RegisterEffect(e7)
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(999103,0))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_RECOVER)
	e8:SetCondition(c999103.cd)
	e8:SetOperation(c999103.op)
	c:RegisterEffect(e8)
end
function c999103.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c999103.chainfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_SPELL)
end
function c999103.cd(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep
end
function c999103.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
