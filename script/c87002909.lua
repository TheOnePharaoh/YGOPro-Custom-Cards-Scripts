--May-Raias Blood Golem
function c87002909.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002909,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(87002909)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c87002909.condition1)
	e1:SetTarget(c87002909.target1)
	e1:SetOperation(c87002909.operation1)
	c:RegisterEffect(e1)
	--be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87002909,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCost(c87002909.cost)
	e2:SetTarget(c87002909.target2)
	e2:SetOperation(c87002909.operation2)
	c:RegisterEffect(e2)
	--atk/def up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87002909,2))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c87002909.adcon)
	e3:SetOperation(c87002909.adop)
	c:RegisterEffect(e3)
	if not c87002909.global_check then
		c87002909.global_check=true
		c87002909[0]=0
		c87002909[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c87002909.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c87002909.check2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c87002909.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c87002909.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetAttackTarget()==nil then
		c87002909[1-tc:GetControler()]=c87002909[1-tc:GetControler()]+1
		if c87002909[1-tc:GetControler()]==1 then
			c87002909[2]=tc
			tc:RegisterFlagEffect(87002909,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		elseif c87002909[1-tc:GetControler()]==2 then
			Duel.RaiseEvent(tc,87002909,e,0,0,0,0)
		end
	end
end
function c87002909.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(87002909)~=0 and Duel.GetAttackTarget()~=nil then
		c82670878[1-tc:GetControler()]=c87002909[1-tc:GetControler()]-1
	end
end
function c87002909.clear(e,tp,eg,ep,ev,re,r,rp)
	c87002909[0]=0
	c87002909[1]=0
end
function c87002909.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()==nil and c87002909[tp]==2
end
function c87002909.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c87002909.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
	end
end
function c87002909.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c87002909.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c87002909[2]
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if tc and tc:GetFlagEffect(87002909) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetValue(tc:GetAttack())
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(tc:GetDefense())
			c:RegisterEffect(e2)
		end
	end
end
function c87002909.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c87002909.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c87002909.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end