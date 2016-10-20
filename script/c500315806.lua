function c500315806.initial_effect(c)
c:SetSPSummonOnce(500315806)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
       local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c500315806.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)

			--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c500315806.spcon)
	c:RegisterEffect(e4)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(500315806,0))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c500315806.condition)
	e6:SetCost(c500315806.cost)
	e6:SetTarget(c500315806.target)
	e6:SetOperation(c500315806.operation)
	c:RegisterEffect(e6)
end

function c500315806.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c500315806.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c500315806.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end
function c500315806.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:GetLevel()==8 or c:GetRank()==8 
end
function c500315806.indcon(e)
	return  Duel.IsExistingMatchingCard(c500315806.spfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c500315806.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c500315806.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end


function c500315806.condition(e,tp,eg,ep,ev,re,r,rp)
	return  bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c500315806.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c500315806.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c500315806.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT) ~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabel(p)
    e1:SetCountLimit(1)
    e1:SetOperation(c500315806.rmop)
    Duel.RegisterEffect(e1,tp)
end
end
function c500315806.rfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785b) and c:GetCode()~=500315806
end
function c500315806.rmop(e,tp,eg,ep,ev,re,r,rp)
    local p=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(p,c500315806.rfilter,p,LOCATION_HAND,0,1,1,nil)
    local tg=g:GetFirst()
    if tg then
        if tg:IsFacedown() then
            Duel.ConfirmCards(1-p,tg)
            Duel.ShuffleHand(p)
        end
    else
        local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end