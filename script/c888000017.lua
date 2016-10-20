--Evil HERO Wild Slasher
function c888000017.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,86188410,58554959,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000017.splimit)
	c:RegisterEffect(e1)
	--attackall
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE_CALCULATING)
	e3:SetCondition(c888000017.indescon)
	e3:SetOperation(c888000017.indesop)
	c:RegisterEffect(e3)
	--check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c888000017.condition)
	e4:SetOperation(c888000017.checkop)
	c:RegisterEffect(e4)
	--Attacked
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e5:SetProperty(EFFECT_FLAG_REPEAT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c888000017.attg)
	e5:SetOperation(c888000017.atop)
	c:RegisterEffect(e5)
end
c888000017.dark_calling=true
function c888000017.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000017.indescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c888000017.indesop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	bc:RegisterEffect(e1,true)
end
function c888000017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c888000017.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetBattleTarget()
	tg:RegisterFlagEffect(888000017,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c888000017.filter(c,e,tp)
	return c:GetFlagEffect(888000017)~=0 and c:IsFaceup()
end
function c888000017.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c888000017.filter,tp,0,LOCATION_MZONE,1,nil,tp) 
	and Duel.GetTurnPlayer()==e:GetHandler():GetControler() end
	local g=Duel.GetMatchingGroup(c888000017.filter,tp,0,LOCATION_MZONE,nil)
	local dg=g:Filter(c888000017.filter,nil,e,tp)
	g:Clear()
	Duel.SetTargetCard(dg)
end
function c888000017.atfilter(c,e,tp)
	return c:IsRelateToEffect(e)
end
function c888000017.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c888000017.filter,tp,0,LOCATION_MZONE,nil)
	local sg=g:Filter(c888000017.filter,nil,e,tp)
	local tc=sg:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if tc:IsDefensePos() then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(888000017,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,0)
		c:CreateRelation(tc,RESET_EVENT+0x1020000+RESET_PHASE+PHASE_BATTLE)
		tc=sg:GetNext()
	end
end