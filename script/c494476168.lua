function c494476168.initial_effect(c)
  --fusion summon
	  aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x0600),3,true)
    c:EnableReviveLimit()
    --atk announce and copy
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(494476168,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c494476168.cptg)
	e1:SetOperation(c494476168.cpop)
	c:RegisterEffect(e1)
	  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(494476168,0))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
  e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e2:SetCondition(c494476168.atkcon)
  e2:SetOperation(c494476168.atkop)
  c:RegisterEffect(e2)
    --cannot effect targret
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgval)
	c:RegisterEffect(e3)
	  local e4=e3:Clone()
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c494476168.efilter)
	c:RegisterEffect(e4)
  --cannot be destroyed by battle
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c494476168.indes)
	c:RegisterEffect(e5)
  local e6=e5:Clone()
  e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e6)
end

function c494476168.cpfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c494476168.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c494476168.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c494476168.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c494476168.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end
function c494476168.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	end
end

function c494476168.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return bc and bc:GetAttribute()~=c:GetAttribute()
end

function c494476168.atkop(e,tp,eg,ep,ev,re,r,rp)
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

function c494476168.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c494476168.indes(e,c)
  local bc=c:GetBattleTarget()
  return bc and bc:GetAttribute()~=c:GetAttribute()
end

