--Evil HERO Life Regainer
function c888000013.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,58932615,79979666,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000013.splimit)
	c:RegisterEffect(e1)
	--Switch LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000013,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c888000013.swcon)
	e2:SetOperation(c888000013.swop)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c888000013.atkval)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888000013,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLED)
	e4:SetTarget(c888000013.rectg)
	e4:SetOperation(c888000013.recop)
	c:RegisterEffect(e4)
end
c888000013.dark_calling=true
function c888000013.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000013.swcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.GetLP(tp)<=Duel.GetLP(1-tp)-4000
end
function c888000013.swop(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	Duel.SetLP(tp,lp2)
	Duel.SetLP(1-tp,lp1)
end
function c888000013.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=bc:GetAttack()
	local def=bc:GetDefense()
	local rec=atk+def
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(e:GetHandlerPlayer())
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,e:GetHandlerPlayer(),rec)
end
function c888000013.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c888000013.atkval(e,c)
	local dif=Duel.GetLP(e:GetHandlerPlayer())-Duel.GetLP(1-e:GetHandlerPlayer())
	if dif>0 then
		return dif>1200 and 1200 or dif
	else return 0 end
end