--Awaking the Ancient Spirits
function c66165094.initial_effect(c)
	c:SetUniqueOnField(1,0,66165094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetCondition(c66165094.condition)
	e1:SetTarget(c66165094.target1)
	e1:SetOperation(c66165094.operation)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c66165094.target2)
	e2:SetOperation(c66165094.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c66165094.distg)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13212303,2))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c66165094.reccon)
	e4:SetTarget(c66165094.rectg)
	e4:SetOperation(c66165094.recop)
	c:RegisterEffect(e4)
	--self destruct
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c66165094.descon)
	e5:SetOperation(c66165094.desop)
	c:RegisterEffect(e5)
end
function c66165094.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xea010) and bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c66165094.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66165094.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c66165094.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res then
		local g=teg:Filter(c66165094.filter1,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(66165094,0)) then
			Duel.SetTargetCard(g)
			Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
			e:SetLabel(1)
			e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(66165094,1))
		end
	end
end
function c66165094.filter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsType(TYPE_EFFECT)
end
function c66165094.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c66165094.filter1,1,nil) end
	local g=eg:Filter(c66165094.filter1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c66165094.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)
	end
end
function c66165094.distg(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c66165094.reccon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	local rc=eg:GetFirst()
	return rc:IsControler(tp) and rc:IsSetCard(0xea010)
end
function c66165094.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c66165094.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c66165094.dfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xea010) and c:GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c66165094.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66165094.dfilter,1,nil,tp)
end
function c66165094.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
