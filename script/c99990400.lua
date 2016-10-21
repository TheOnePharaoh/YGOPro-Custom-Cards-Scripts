--SAO - Sinon ALO
function c99990400.initial_effect(c)
    --Synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,9999))
	c:EnableReviveLimit()
	--Discard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99990400.condition)
	e1:SetTarget(c99990400.target)
	e1:SetOperation(c99990400.operation)
	c:RegisterEffect(e1)
	--Direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--ATK/DEF
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c99990400.atkcon)
	e3:SetOperation(c99990400.atkop)
	c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c99990400.atkcon2)
	e4:SetOperation(c99990400.atkop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c99990400.atkcon3)
	e5:SetOperation(c99990400.atkop)
	c:RegisterEffect(e5)
	--Damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c99990400.damcon)
	e6:SetTarget(c99990400.damtg)
	e6:SetOperation(c99990400.damop)
	c:RegisterEffect(e6)
end
function c99990400.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>0
end
function c99990400.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c99990400.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
    end
end
function c99990400.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsReason(REASON_BATTLE) and bc:IsRelateToBattle() and bc:IsControler(tp) and bc:IsSetCard(9999)
end
function c99990400.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	if tc==nil then return false
	elseif tc:IsType(TYPE_MONSTER) and bc:IsControler(tp) and bc:IsSetCard(9999) and tc:IsReason(REASON_BATTLE) and bc:IsReason(REASON_BATTLE) then return true end
end
function c99990400.atkcon3(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	if tc==nil then return false
	elseif bc:IsType(TYPE_MONSTER) and tc:IsControler(tp) and tc:IsSetCard(9999) and bc:IsReason(REASON_BATTLE) and tc:IsReason(REASON_BATTLE) then return true end
end
function c99990400.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c99990400.filter1(c)
	return c:IsFaceup() and c:IsSetCard(9999) and c:IsType(TYPE_MONSTER)
end
function c99990400.damcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c99990400.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99990400.filter1,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c99990400.filter1,tp,LOCATION_MZONE,0,nil)
	local val=sg:GetCount()*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c99990400.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local sg=Duel.GetMatchingGroup(c99990400.filter1,tp,LOCATION_MZONE,0,nil)
	local val=sg:GetCount()*200
	Duel.Damage(p,val,REASON_EFFECT)
end