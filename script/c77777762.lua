--Hellformed Girl Rosebud
function c77777762.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77777762,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77777762.lvtg)
	e2:SetOperation(c77777762.lvop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c77777762.splimit)
	c:RegisterEffect(e3)
	--atk down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c77777762.val)
	c:RegisterEffect(e4)
	--become material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetDescription(aux.Stringid(77777762,1))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c77777762.matcon)
	e5:SetTarget(c77777762.mattg)
	e5:SetOperation(c77777762.matop)
	c:RegisterEffect(e5)
	--atk up
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3e7))
	e6:SetValue(100)
	c:RegisterEffect(e6)
end

function c77777762.val(e,c)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()*-50
	end
	
	return c:GetLevel()*-50
end

function c77777762.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_FIEND) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end


function c77777762.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777762.lvfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8)
	e:SetLabel(lv)
end
function c77777762.lvfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x3e7) and not c:IsType(TYPE_XYZ)
end
function c77777762.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777762.lvfilter2,tp,LOCATION_MZONE,0,tc)
	local lc=g:GetFirst()
	local lv=e:GetLabel()
	while lc~=nil do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
end

function c77777762.matcon(e,tp,eg,ep,ev,re,r,rp)
	return (r==REASON_RITUAL or r==REASON_SYNCHRO or r==REASON_FUSION)and e:GetHandler():GetReasonCard():IsSetCard(0x3e7)
end
function c77777762.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77777762.matop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local rc=e:GetHandler():GetReasonCard()
	if rc:IsSetCard(0x3e7) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)~=0 then
			--gains atk
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(77777762,1))
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			rc:RegisterEffect(e1,true)
		end
	end
end