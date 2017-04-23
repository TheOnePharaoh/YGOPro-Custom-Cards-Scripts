--The Idol Master of Purity and Fertility Nikaidou Yuzu
function c59821167.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c59821008.splimit)
	e2:SetCondition(c59821008.splimcon)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-200)
	c:RegisterEffect(e3)
	--subtitute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(59821167)
	c:RegisterEffect(e4)
	--spsummon1
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e5:SetCountLimit(1,59821167)
	e5:SetCondition(c59821167.spcon)
	e5:SetTarget(c59821167.sptg)
	e5:SetOperation(c59821167.spop)
	c:RegisterEffect(e5)
	--effect
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821167,0))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(c59821167.effcon)
	e6:SetTarget(c59821167.efftg)
	e6:SetOperation(c59821167.effop)
	c:RegisterEffect(e6)
	--add setcode
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_ADD_SETCODE)
	e7:SetValue(0xa1a4)
	c:RegisterEffect(e7)
	if not c59821167.global_check then
		c59821167.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(59821167)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,59821167))
		Duel.RegisterEffect(ge1,0)
	end
end
function c59821167.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xa1a2) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c59821167.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c59821167.locfilter(c)
    return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c59821167.cofilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0xa1a2)
		and (c:IsPreviousLocation(LOCATION_MZONE) or c59821167.locfilter(c)) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c59821167.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c59821167.cofilter,1,nil,tp)
end
function c59821167.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,500)
end
function c59821167.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c59821167.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821167.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
end
function c59821167.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
			e1:SetValue(-500)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	else
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end