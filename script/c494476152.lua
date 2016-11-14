function c494476152.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(494476152,1))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c494476152.ntcon)
	c:RegisterEffect(e1)
  --atk condition
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(494476152,2))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e2:SetCondition(c494476152.atkcon)
    e2:SetOperation(c494476152.atkop)
    c:RegisterEffect(e2)
end
function c494476152.filter(c)
	return c:IsFaceup() and c:GetLevel()==8 and c:IsSetCard(0x600)
end
function c494476152.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c494476152.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c494476152.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return bc and bc:GetAttribute()~=c:GetAttribute()
end

function c49447612.atkop(e,tp,eg,ep,ev,re,r,rp)
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

