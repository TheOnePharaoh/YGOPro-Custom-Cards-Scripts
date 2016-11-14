--Necro Doll - Annalilith
function c494476151.initial_effect(c)
--atkcondition
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(494476151,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCondition(c494476151.atkcon)
    e1:SetOperation(c494476151.atkop)
    c:RegisterEffect(e1)
--special summon
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c494476151.spcon)
	e2:SetOperation(c494476151.spop)
	c:RegisterEffect(e2)
--cannot be destoyed by battle with different attribute
  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c494476151.indes)
	c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e4)
end

function c494476151.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),1000)
end

function c494476151.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,1000)
end

function c494476151.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return bc and bc:GetAttribute()~=c:GetAttribute()
end

function c494476151.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        e1:SetValue(bc:GetAttack()*2)
        c:RegisterEffect(e1)
    end
end

function c494476151.indes(e,c)
  local bc=c:GetBattleTarget()
  return bc and bc:GetAttribute()~=c:GetAttribute()
end

